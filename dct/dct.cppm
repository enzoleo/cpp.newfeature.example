export module dct;

import <numbers>;
import <cmath>;
import <vector>;
import <iostream>;

export
namespace dct {

template<class InputIt, class OutputIt>
auto naive_dct(InputIt first, InputIt last, OutputIt d_first) {
  // The total length of input iterable object.
  auto len = std::distance(first, last);//std::distance(first, last);
  double factor = std::numbers::pi / static_cast<double>(len);

  // The discrete cosine transform loop.
  for (std::size_t i = 0; i < len; ++i) {
    auto iter = d_first + i;
    *iter = 0; // Initialize the element.
    for (std::size_t j = 0; j < len; ++j)
      *iter += *(first + j) * std::cos((j + 0.5) * i * factor);
  }
  return d_first + len;
}

} // namespace dct

