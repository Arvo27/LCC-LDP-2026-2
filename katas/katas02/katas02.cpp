#include <iostream>
#include <cstdint>

//Forma recursiva factorial

uint64_t factorial_rec(uint64_t n) {
    if (n == 0 || n == 1) {
        return 1;
    }
    return n * factorial_rec(n - 1);
}

uint64_t factorial_iter(uint64_t n) {
    uint64_t result = 1;
    for(uint64_t i = 1; i <= n; ++i) {
        result *= i;
    }
    return result;
}



int main() {

    // Llamar factorial_rec
    std::cout << "Factorial recursivo de 5: " << factorial_rec(5) << std::endl;

    // Llamar factorial_iter
    std::cout << "Factorial iterativo de 5: " << factorial_iter(5) << std::endl;


    return 0;
}