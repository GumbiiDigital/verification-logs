# Pipeline Technical Details

## MuseTalk Patches (aarch64/PyTorch 2.10)
7 files patched:
- musetalk/utils/preprocessing.py — face_detection import path
- musetalk/utils/face_detection/api.py — __import__ path fix
- musetalk/utils/face_parsing/resnet.py — weights_only=False
- musetalk/utils/face_parsing/__init__.py — weights_only=False
- musetalk/utils/face_detection/detection/sfd/sfd_detector.py — weights_only=False
- musetalk/models/unet.py — weights_only=False
- System: mmengine checkpoint.py, mmdet version check, PyTorch cpp_extension.py

## GFPGAN Patches
- basicsr/data/degradations.py — torchvision.transforms.functional_tensor fallback
- basicsr/archs/arch_util.py — distutils.version.LooseVersion fallback

## LivePortrait PKL Templates
- PKL templates (talking.pkl, etc.) have KeyError 'c_d_eyes_lst' — format incompatible
- Use mp4 driving videos with --driving-multiplier to control intensity
- d18.mp4 is short (7.2s) and relatively subtle

## Quality Issues Log
- 2026-03-09: User reviewed comparison_sidebyside.mp4
  - Combo (LP d6 + MuseTalk): "massive face twitching and eye movement"
  - MuseTalk-only: "frozen face, just lips moved"
  - Both approaches need improvement
  - v2 attempt: LP d18 at 0.5x multiplier -> MuseTalk (untested by user yet)
  - SadTalker install in progress as single-model alternative

## File Server
- python3 -m http.server 8080 from ~/projects/review/
- Must restart after adding new files
