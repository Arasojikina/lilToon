# Fork notes (Arasojikina/lilToon)

Personal fork of [lilxyzw/lilToon](https://github.com/lilxyzw/lilToon) with one patch. MIT license, unchanged.

## Patch: cap the POM loop at 64 (`fork/pom-loop-cap.patch`)

`lilPOM` in `Assets/lilToon/Shader/Includes/lil_common_functions.hlsl` loops `LIL_POM_DETAIL * 2 * parallaxScale` times.
With this loop compiled in, the GPU hangs (TDR, DXGI 887a0005 / nvlddmkm 153) when all of these hold:

- Unity 6000.5 + URP 17.5 with the SRP Batcher on
- two or more materials using the two-pass transparent shaders (TwoPassTransparent / TransparentOutline)
- the back pass contains the POM loop code (LIL_FEATURE_POM on, which lilToon re-enables on every graphics API switch)

It happens on D3D11, D3D12 and Vulkan (RTX 5090, driver 616.92), even though `_UsePOM` is 0 and the loop never runs.
Unity's DXBC looks correct, so it is most likely a driver compile bug. Capping the loop at 64 stops the hang.

## Updating to a new lilToon version

```
git fetch https://github.com/lilxyzw/lilToon.git tag <ver> --no-tags
git checkout -b fork-<ver> <ver>
git apply fork/pom-loop-cap.patch   # or: bash fork/reapply.sh <ver>
git add -A && git commit -m "Cap POM loop at 64 (fork)" && git tag <ver>-fork1
git push origin fork-<ver> <ver>-fork1
```

Then point the project manifest at `https://github.com/Arasojikina/lilToon.git?path=Assets/lilToon#<ver>-fork1`.
