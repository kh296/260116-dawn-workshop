"""
Python code for checking xpu devices (Intel GPUs) seen by torch.
"""
import importlib
import socket
import torch

print(f"\nDevices seen by torch on {socket.gethostname()}:")
devices = ["xpu", "cuda", "mps", "cpu"]
len_device_field = max(len(device) for device in devices)

for device in devices:
    try:
        device_module = importlib.import_module(f"torch.{device}")
    except ModuleNotFoundError:
        device_module = None
    if getattr(device_module, "is_available", lambda: False)():
        n_device = device_module.device_count()
    else:
        n_device = 0

    print(f"{device:<{len_device_field}} : {n_device}")
    for idx in range(n_device):
        try:
            print(f"    {device_module.get_device_properties(idx).name}")
        except AttributeError:
            pass
