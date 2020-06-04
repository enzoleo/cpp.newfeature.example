#include <iostream>
#include <vector>

// Import dct module.
import dct;

int main() {
  // Define the original vector and the destination vector.
  std::vector<double> v { 1.5, 2.7, 3.9, 0.4, 5.3, 1.2, 7.5, 9.9, 4.2, 6.0 };
  std::vector<double> res(v.size(), 0);
  
  // Run naive dct on the original vector and save the result into @res.
  dct::naive_dct(v.data(), res.data(), v.size());

  // Output result vector @res.
  for (auto elem : res) std::cout << elem << ' ';
  std::cout << '\n';
  
  return 0;
}
