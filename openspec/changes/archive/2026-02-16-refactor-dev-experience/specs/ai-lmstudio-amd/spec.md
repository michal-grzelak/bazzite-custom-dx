## ADDED Requirements

### Requirement: clblast dependency installed for AMD/Intel GPU acceleration
The system SHALL install clblast library for LM Studio GPU support on AMD/Intel graphics.

#### Scenario: clblast installation
- **WHEN** the image is built for AMD/Intel GPU systems (recipe-bazzite.yml)
- **THEN** clblast package is installed via dnf module
- **THEN** libclblast.so symlinks are created in /usr/local/lib/ for LM Studio compatibility

### Requirement: OpenCL runtime available
The system SHALL ensure OpenCL runtime is available for AMD/Intel GPUs.

#### Scenario: OpenCL runtime
- **WHEN** the image is built for AMD/Intel GPU systems
- **THEN** mesa-libOpenCL or equivalent OpenCL runtime is available
- **THEN** LM Studio can utilize GPU acceleration for model inference

## Notes

- This capability is specific to AMD/Intel GPU systems
- NVIDIA systems should NOT install clblast (they use CUDA/cuBLAS)
- This module should be included by recipe-bazzite.yml (AMD/main) but NOT by recipe-bazzite-nvidia.yml
- Bazzite base image already includes ROCm for AMD; this adds the OpenCL BLAS library specifically for LM Studio
