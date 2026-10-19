import hashlib
import struct
import tempfile
import unittest
import zlib
from pathlib import Path

from tools.media_manifest import build_manifest


def make_png(width: int, height: int) -> bytes:
    signature = b"\x89PNG\r\n\x1a\n"
    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    ihdr = b"IHDR" + ihdr_data
    return signature + struct.pack(">I", len(ihdr_data)) + ihdr + struct.pack(">I", zlib.crc32(ihdr))


class MediaManifestTests(unittest.TestCase):
    def test_records_hash_size_dimensions_and_stable_path_order(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            png = make_png(1920, 1080)
            (root / "z.png").write_bytes(png)
            (root / "a.mp4").write_bytes(b"preview")
            (root / "ignored.txt").write_text("not media", encoding="utf-8")

            manifest = build_manifest(root, ffprobe=None)

            self.assertEqual(manifest["file_count"], 2)
            self.assertFalse(manifest["ffprobe_available"])
            self.assertEqual([item["path"] for item in manifest["files"]], ["a.mp4", "z.png"])
            self.assertEqual(manifest["files"][1]["bytes"], len(png))
            self.assertEqual(manifest["files"][1]["sha256"], hashlib.sha256(png).hexdigest())
            self.assertEqual(manifest["files"][1]["width"], 1920)
            self.assertEqual(manifest["files"][1]["height"], 1080)


if __name__ == "__main__":
    unittest.main()
