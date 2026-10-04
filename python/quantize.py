import numpy as np


INT8_MIN = -128
INT8_MAX = 127


def quantize_int8(values, scale):
    """
    Quantize floating-point values to signed INT8.
    """

    values = np.array(values, dtype=np.float32)

    quantized = np.round(values / scale)

    quantized = np.clip(
        quantized,
        INT8_MIN,
        INT8_MAX
    )

    return quantized.astype(np.int8)


def dequantize_int8(values, scale):
    """
    Convert INT8 values back to floating point.
    """

    values = np.array(values, dtype=np.int8)

    return values.astype(np.float32) * scale


if __name__ == "__main__":

    # Example CNN weights
    weights = [
        0.12,
        -0.45,
        0.78,
        0.31,
        -0.22,
        0.56,
        -0.91,
        0.17,
        0.63
    ]

    scale = 0.01

    quantized = quantize_int8(
        weights,
        scale
    )

    reconstructed = dequantize_int8(
        quantized,
        scale
    )

    print("INT8 Quantization")
    print("=================")

    print("Original:")
    print(weights)

    print("\nQuantized INT8:")
    print(quantized)

    print("\nReconstructed:")
    print(reconstructed)

    error = np.abs(
        np.array(weights) - reconstructed
    )

    print("\nMaximum quantization error:",
          np.max(error))

    print("\nQUANTIZATION PASSED")
