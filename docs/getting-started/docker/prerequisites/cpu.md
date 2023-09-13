# CPU instructions

In order to run [TensorFlow](https://en.wikipedia.org/wiki/TensorFlow) used by few Open Voice OS components, the [CPU](https://en.wikipedia.org/wiki/Central_processing_unit) must support `AVX` *(Advanced Vector Extensions)* instruction set for x86 processors or `SIMD` *(Single Instruction, Multiple Data)* instruction set for ARM processors.

=== "Linux"

    ```shell
    grep -E -i --color "avx|simd" /proc/cpuinfo
    ```

=== "Mac OS"

    ```shell
    sysctl -a | grep -E -i --color "avx|simd"
    ```

If the command does not return an output then your CPU doesn't meet the requirements for TensorFlow.

!!! example "AVX or SIMD instruction set missing"

    Because the instruction set is missing does not mean that Open Voice OS can't run on your hardware, it simply means that [Precise](https://mycroft-ai.gitbook.io/docs/mycroft-technologies/precise) wake word engine or anything else using TensorFlow will not run on it.
