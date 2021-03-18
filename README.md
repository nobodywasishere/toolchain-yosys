# toolchain-yosys

[Apio](https://github.com/FPGAwars/apio) package that contains the [fpga-toolchain](https://github.com/YosysHQ/fpga-toolchain) nightly releases of Yosys

## How to create a new release

This information is for **developers**

* Clone the toolchain-yosys
* Open the **build.sh** file
* Change the **VERSION** variable to the new version for the Apio package (For example VERSION=2020.10.6)

```
# -- yosys apio package version
VERSION=2020.11.24
```

* Set the **yosys version** to include in the apio package

```
# -- fpga-toolchain version to download
# -- nightly-20201124
SRC_VER="nightly-20201124"
```

* **Save** the file
* **Execute** the building script for all the **architectures** you want to create

It will download the executables from the [fpga-toolchain](https://github.com/open-tool-forge/fpga-toolchain) project and package them for apio

The **apio target architectures** are:

 * linux_x86_64: For linux 64-bits
 * windows_amd64: for windows 64-bits
 * darwin: For Mac
 (Not available for windows 32-bits)

Example: Building the package for Linux

```bash
bash build linux_x86_64
```

* The **apio packages** are stored in the local **releases** folder  
* Create a **new release of toolchain-yosys** on Github in the [FPGAwars/toolchain-yosys](https://github.com/FPGAwars/toolchain-yosys/) repository
The tag and name of the release should start with the **letter v** and have three numbers separated by a colon. Must follow semantic versioning. Ex: v2020.11.24, v2021.3.24
* **Upload the apio packages** from the releases local folder  
* Apio should **upgrade** to the new version with the **install command**:
```
apio install yosys
```
* You can check that the new version is installed with:
```
apio install -l
```

## Authors

* [Carlos Venegas](https://github.com/cavearr)
* [Juan González (Obijuan)](https://github.com/Obijuan)

## Credits

* [Yosys](https://github.com/YosysHQ/yosys), developed by Claire Wolfe and many others
* The [fpga-toolchain](https://github.com/open-tool-forge/fpga-toolchain) project has been developed by Edward Bordin

* The building scripts are based on the [Tools-systems](https://github.com/FPGAwars/tools-system) by
  * [Jesús Arroyo Torrens](https://github.com/Jesus89)
  * [Juan González-Gómez (Obijuan)](https://github.com/Obijuan)
