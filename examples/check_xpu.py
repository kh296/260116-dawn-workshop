"""
Python code for checking xpu devices (Intel GPUs) seen by torch.
"""
import torch

if torch.xpu.is_available():
    print(f"Number of xpu devices: {torch.xpu.device_count()}")
    for i in range(torch.xpu.device_count()):
        print(torch.xpu.get_device_properties(i).name)
else:
    print("No xpu devices available")
