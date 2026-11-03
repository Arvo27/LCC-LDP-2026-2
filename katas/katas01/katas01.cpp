#include <iostream>
#include <vector>

std::vector<int> cuenta_atras(int n) {
    if (n <= 0) {
        return {};
    }

    std::vector<int> result = cuenta_atras(n - 1);
    result.insert(result.begin(), n);
    return result;
}

void imprimir(const std::vector<int>& v) {
    std::cout << "(";
    for (size_t i = 0; i < v.size(); ++i) {
        if (i > 0) std::cout << " ";
        std::cout << v[i];
    }
    std::cout << ")\n";
}

int main() {
    std::vector<int> v = cuenta_atras(5);
    imprimir(v);
    return 0;
}
