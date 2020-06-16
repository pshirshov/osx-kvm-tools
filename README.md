grub
====

```
GRUB_CMDLINE_LINUX="mitigations=off iommu=pt amd_iommu=on"
```

or

```
GRUB_CMDLINE_LINUX="mitigations=off iommu=pt amd_iommu=on isolcpus=8-31,40-63"
```
