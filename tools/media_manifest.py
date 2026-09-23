#!/usr/bin/env python3
"""Create a reproducible manifest for MV source and preview media.

The command never modifies the inspected files.  Video/audio stream metadata is
read with ffprobe when it is available; hashes, byte sizes, and PNG dimensions
are still recorded on machines without ffprobe.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import struct
import subprocess
from datetime import datetime, timezone
from pathlib import Path


MEDIA_SUFFIXES = {
    ".aac", ".flac", ".jpeg", ".jpg", ".m4a", ".mov", ".mp3", ".mp4",
    ".png", ".wav", ".webm",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def png_dimensions(path: Path) -> tuple[int, int] | None:
    with path.open("rb") as source:
        header = source.read(24)
    if len(header) == 24 and header[:8] == b"\x89PNG\r\n\x1a\n":
        return struct.unpack(">II", header[16:24])
    return None


def ffprobe_metadata(path: Path, executable: str) -> dict[str, object]:
    command = [
        executable, "-v", "error", "-show_entries",
        "format=duration:stream=index,codec_type,width,height,r_frame_rate,duration",
        "-of", "json", str(path),
    ]
    result = subprocess.run(command, check=False, capture_output=True, text=True)
    if result.returncode:
        return {"ffprobe_error": result.stderr.strip() or f"exit {result.returncode}"}

    payload = json.loads(result.stdout)
    format_data = payload.get("format", {})
    duration = format_data.get("duration")
    streams = payload.get("streams", [])
    video = next((stream for stream in streams if stream.get("codec_type") == "video"), None)
    metadata: dict[str, object] = {"duration_seconds": float(duration)} if duration else {}
    if video:
        metadata.update(
            width=video.get("width"),
            height=video.get("height"),
            fps=video.get("r_frame_rate"),
        )
    return metadata


def inspect(path: Path, root: Path, ffprobe: str | None) -> dict[str, object]:
    result: dict[str, object] = {
        "path": path.relative_to(root).as_posix(),
        "bytes": path.stat().st_size,
        "sha256": sha256(path),
    }
    dimensions = png_dimensions(path) if path.suffix.lower() == ".png" else None
    if dimensions:
        result.update(width=dimensions[0], height=dimensions[1])
    if ffprobe:
        result.update(ffprobe_metadata(path, ffprobe))
    return result


def build_manifest(root: Path, ffprobe: str | None = None) -> dict[str, object]:
    root = root.resolve()
    files = sorted(
        path for path in root.rglob("*")
        if path.is_file() and path.suffix.lower() in MEDIA_SUFFIXES
    )
    return {
        "schema_version": 1,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "root": str(root),
        "ffprobe_available": bool(ffprobe),
        "file_count": len(files),
        "files": [inspect(path, root, ffprobe) for path in files],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("media_root", type=Path, help="folder containing media to inspect")
    parser.add_argument("--output", type=Path, help="write JSON to this path instead of stdout")
    args = parser.parse_args()
    if not args.media_root.is_dir():
        parser.error(f"media root is not a directory: {args.media_root}")

    manifest = build_manifest(args.media_root, shutil.which("ffprobe"))
    rendered = json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
