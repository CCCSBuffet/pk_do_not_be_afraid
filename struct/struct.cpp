#include <iostream>

using namespace std;

struct Foo
{
	uint32_t a_32_bit_int;
	uint64_t a_64_bit_int;
	uint16_t a_16_bit_int;
	uint32_t a_final_32_bit_int;
};

struct Bar
{
	uint32_t a_32_bit_int;
	uint32_t a_final_32_bit_int;
	uint64_t a_64_bit_int;
	uint16_t a_16_bit_int;
};

struct Billy
{
	uint8_t	a_char_01;
	uint16_t a_16_bit_int;
	uint8_t a_char_02;
	uint8_t a_char_03;
};

int main()
{
	struct Foo f;
	struct Bar b;
	struct Billy y;

	cout << "sizeof(Foo):   " << sizeof(Foo) << endl;
	cout << "Member:        Offset:\n";
	cout << "a_32_bit_int   " << (long)&f.a_32_bit_int - (long)&f << endl;
	cout << "a_64_bit_int   " << (long)&f.a_64_bit_int - (long)&f << endl;
	cout << "a_16_bit_int   " << (long)&f.a_16_bit_int - (long)&f << endl;
	cout << "a_32_bit_int   " << (long)&f.a_final_32_bit_int - (long)&f << endl << endl;

	cout << "sizeof(Bar):   " << sizeof(Bar) << endl;
	cout << "Member:        Offset:\n";
	cout << "a_32_bit_int   " << (long)&b.a_32_bit_int - (long)&b << endl;
	cout << "a_32_bit_int   " << (long)&b.a_final_32_bit_int - (long)&b << endl;
	cout << "a_64_bit_int   " << (long)&b.a_64_bit_int - (long)&b << endl;
	cout << "a_16_bit_int   " << (long)&b.a_16_bit_int - (long)&b << endl << endl;

	cout << "sizeof(Billy): " << sizeof(Billy) << endl;
	return 0;
}