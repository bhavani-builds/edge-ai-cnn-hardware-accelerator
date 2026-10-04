import numpy as np


def convolution_3x3(image, kernel):
    """
    Software reference model for a single 3x3 convolution.
    """

    image = np.array(image, dtype=np.int32)
    kernel = np.array(kernel, dtype=np.int32)

    result = np.sum(image * kernel)

    return int(result)


def relu(value):
    """
    ReLU activation.
    """

    return max(0, value)


def max_pool_2x2(values):
    """
    2x2 maximum pooling.
    """

    values = np.array(values, dtype=np.int32)

    return int(np.max(values))


if __name__ == "__main__":

    image = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]

    kernel = [
        [1, 0, -1],
        [1, 0, -1],
        [1, 0, -1]
    ]

    conv_result = convolution_3x3(
        image,
        kernel
    )

    relu_result = relu(
        conv_result
    )

    print("CNN Reference Model")
    print("===================")

    print("Convolution :", conv_result)
    print("ReLU        :", relu_result)

    assert conv_result == -6
    assert relu_result == 0

    print()
    print("REFERENCE MODEL PASSED")
