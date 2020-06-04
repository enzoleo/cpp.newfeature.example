export module dct;

import <numbers>;

export
namespace dct {

double* naive_dct(const double* src, double* dst, unsigned len) {
  // The total length of input iterable object.
  double factor = std::numbers::pi / static_cast<double>(len);

  // The discrete cosine transform loop.
  for (unsigned i = 0; i < len; ++i) {
    auto iter = dst + i;
    *iter = 0; // Initialize the element.
    for (unsigned j = 0; j < len; ++j)
      *iter += *(src + j) * std::cos((j + 0.5) * i * factor);
  }
  return dst + len;
}

} // namespace dct

