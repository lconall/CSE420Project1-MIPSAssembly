# CSE 420 - Computer Architecture
## Project 1 - MIPS Assembly Language
### Author: Levi Conall <l.conall@asu.edu>

----

### Objective:
Learn to program in MIPS assembly language.


### Tool Used:
MIPS Assembler and Runtime Simulator ([MARS](http://courses.missouristate.edu/KenVollmar/mars/))

<b><i>Note: MARS 4.5 was used and is stored in the Tools directory of this repository.</i></b>

### Usage:
1. Open MARS

2. Open desired problem program in MARS.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>File -> Open -> Navigate to problem program -> Open</i>

3. Assemble the program.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Run -> Assemble</i>

4. Run the program

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Run -> Go</i>

----

### Problem 1: String handling
Declare a string in the data section:
```
.data
	string: .asciiz "WELCOME TO COMPUTER ARCHITECTURE CLASS!"
```

Write a program that converts the upper-case strings to lower-case string. To convert an uppercase
character to lower case, you can add 0x20 to that character in the string.

----

### Problem 2: Arithmetic expressions
Write a program to evaluate the following function in u and v:

>3u<sup>2</sup> + 7uv - v<sup>2</sup> + 1

Here, the variables u and v, are user inputs, and the program should receive them from the user
at run-time. Then it should print the outcome computed as per given arithmetic expression.

[To understand how to take the user input or write on console, please refer to the sample MIPS
Example programs]. <b><i>Note: The Examples were provided by the instructor.</b></i>

You are required to create and use two subroutines for this program shown below in C.
Pay attention to the registers used for passing arguments to subroutine, and also the registers
used for returning the output from a subroutine.

#### Subroutines Required

<b><u>Square function</u></b>
```c
int Square (a){
	return a^2;
}
```  

<b><u>Multiply function</u></b>
```c
int Multiply (a, b){
	return a * b;
}
```

----

### Problem 3: Pointers

Write a program in MIPS assembly language that will compute the sum of all the elements in an
array. Write this program using a function “updateSum,” that takes two parameters; a pointer
to the running total, and a pointer to the current element.

[To get help on how to deal with the pointers in MIPS assembly, refer to the sample MIPS Examples.] <b><i>Note: The MIPS Examples were provided by the instructor.</b></i>

The “C” program looks like this:
```c
int sum = 0;
int *sumPtr = &sum;
int array[10];

void updateSum(int *total, int *element){
	*total += *element;
}

int main(){
	for (int i = 0; i < 10; i++){
		array[i] = 3(i + 1);
	}

    for (int i = 0; i < 10; i++){
		updateSum(sumPtr, array[i]);
	}

	printf("Sum = %d", sum);
}
```

---

### Problem 4: Recursion

Write a program in MIPS assembly language to find compute(i, x), where compute (i, x) is
defined recursively in C as:

```c
int compute (int i, int x)
	if (x > 0)
		return compute(i, x - 1) + 1;
	else if (i > 0)
		return compute(i - 1, i - 1) + 5;
	else
		return 1;
}
```

Note: Your program should print on the console the computed value compute(i, x). The values
for variables i and x are user inputs to the program. So, your MIPS program should allow the
user to enter values for variables i and x at run-time.

----
