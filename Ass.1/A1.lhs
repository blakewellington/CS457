----------------------------------------------------------------------
CS457/557 Functional Languages, Winter 2014                 Homework 1
                          Blake Wellington               Jan. 14, 2014
----------------------------------------------------------------------
----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
1. Explain what the following Haskell function does:

> dup    :: (a -> a -> a) -> a -> a
> dup f x = f x x

--------------------------    Answer:   ------------------------------
The dup function takes a function and a single argument and returns
the value of the function with the argument duplicated.

Testing this:
*Main> dup (+) 4
8
*Main> dup (+) 2
4
*Main> dup (*) 3
9
*Main> dup (/) 9
1.0

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
Now Consider the following two functions, and show how each of them
can be rewritten using dup:

double  :: Integer -> Integer
double n = 2 * n

square  :: Integer -> Integer
square n = n * n

--------------------------    Answer:   ------------------------------
The previous functions can use the dup function as written below. Since
the dup function duplicates the arguments of a function, it can be used
in functions that use a given argument twice, such as squaring or 
doubling a number.

> double :: Integer -> Integer
> double n = dup (+) n

> square :: Integer -> Integer
> square n = dup (*) n

Testing double:

*Main> double 4
8
*Main> double 13
26
*Main> double (-5)
-10

and for square:

*Main> square 2
4
*Main> square 99
9801
*Main> square (-5)
25


----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
2. Without using any explicit recursion, given Haskell definitions for
the following functions:

- powerOfTwo :: Int -> Integer
  (powerOfTwo n) returns the value of 2 to the power n.  For example,
  powerOfTwo 8 should return 256.  Of course, your answer should *not*
  use the built in Haskell functions for raising a value to a power :-)

--------------------------    Answer:   ------------------------------
Since Haskell works well against lists, this task can be converted into
one involving lists. The product function can be applied to a list of
numbers to multiply them all together. Applied to this problem, the 
list of numbers could be a list of 2s [2, 2, 2, ... 2] such that the
number of elements is equal to the power n. By applying the product
function to this list, we can generate a powerOfTwo function.

To generate a list of 2s, we can use the built-in repeat function, 
then apply the take function to that.  For example, to generate a list
such as [2, 2, 2, 2, 2] (a list of 5 2s), we can use the following
Haskell code:

  take 5 (repeat 2)

It is then a simple matter to apply the product function to the 
resulting list.

  product (take 5 (repeat 2))

Turning this into a function, we have:

> powerOfTwo :: Int -> Integer
> powerOfTwo n = product (take n (repeat 2))

Note: This solution works only for positive integers. In order to make
it work for negative values of n, we would have to put in a different
type signature and implement a guard as below.

powerOfTwo :: Int -> Float
powerOfTwo n
     | n >= 0    = product (take n (repeat 2))
     | otherwise = (1/) (product (take n (repeat 2))

But, since you gave us the Int -> Integer signature...

Testing:

*Main> powerOfTwo 3
8
*Main> powerOfTwo 9
512
*Main> powerOfTwo 32
4294967296
*Main> powerOfTwo (-3)
1
*Main> powerOfTwo 0
1
*Main> powerOfTwo 1
2

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
- logTwo :: Integer -> Int
  (logTwo v) returns the smallest integer n such that v < powerOfTwo n.

--------------------------    Answer:   ------------------------------
There are undoubtedly many ways to solve this.  To develop this 
non-recursively, I decided to use a comprehension to build a list of
numbers that could be tested.

The comprehension below yields a list of integers starting with the set
of all positive integers ([1..]), then limiting that to just those
integers that are larger than the log of v (v < powerOfTwo n).
Finally, taking the head of the list gives us the smallest integer n
such that v < powerOfTwo n.

> logTwo :: Integer -> Int
> logTwo v =  head [n | n <- [1..], v < (powerOfTwo n)]

Note: This also does not work with negative values of v.

Testing:
*Main> logTwo 44
6
*Main> logTwo 0
1
*Main> logTwo 1
1
*Main> logTwo 2
2
*Main> logTwo 3
2
*Main> logTwo 4
3
*Main> lotTwo 5

*Main> logTwo 5
3
*Main> logTwo 1024
11
*Main> logTwo 1023
10
*Main> logTwo 1025
11

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
- copy :: Int -> a -> [a]
  (copy n x) returns a list containing n copies of the value x.  For
  example, copy 3 True should give [True, True, True].  (The Haskell
  prelude includes a similar function called replicate; of course,
  you should not use replicate in your answer; you should not replicate
  replicate either :-)

--------------------------    Answer:   ------------------------------
This version of copy uses the repeat prelude function to build an 
infinitely long list of repeating values, then takes the first n
values in that list.

> copy :: Int -> a -> [a]
> copy n x = take n (repeat x)

Testing:
*Main> copy 4 True
[True,True,True,True]
*Main> copy 9 2
[2,2,2,2,2,2,2,2,2]
*Main> copy 36 "Hello, Mark Jones!"
["Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!",
"Hello, Mark Jones!","Hello, Mark Jones!","Hello, Mark Jones!"]
*Main> copy 5 ["Hello","Mark","Jones"]
[["Hello","Mark","Jones"],["Hello","Mark","Jones"],["Hello","Mark","Jones"],["Hello","Mark","Jones"],["Hello","Mark","Jones"]]

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
- multiApply :: (a -> a) -> Int -> a -> a
  (multiApply f n x)  returns the value that is obtained when the
  function f is applied n times to the value x.  For example,
  multiApply square 2 2, should return 16, while
  multiApply not 0 True will return True.

--------------------------    Answer:   ------------------------------
To apply a function multiple times, one can employ the iterate function.
The iterate function applies a function to a starting value and repeats
indefinitely. By choosing some defined element of the resulting list, 
using the !! operator, we can implement multiApply.

> multiApply :: (a -> a) -> Int -> a -> a
> multiApply f n x = (iterate f x ) !! n

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
Now suppose that we define the following function using multiApply:

> q f n m x = multiApply (multiApply f n) m x

What is the type of this function, and what exactly does it do?

--------------------------    Answer:   ------------------------------
The q function is of type (a -> a) -> Int -> Int -> a -> a 
To test this, I ran the following command:

:type q

which returns

q :: (a -> a) -> Int -> Int -> a -> a

So the q function takes as arguments a function of type (a -> a),
two Ints, and a polymorphic type (a) and returns the same polymorphic
type.

As for what it does...

Haskell functions can be descried as "curried", meaning they take 
their arguments one at a time.  The q function could also be said to
take the left-most multiApply with three arguments:
	1. (multiApply f n)
	2. m
	3. x

The first argument returns a function, which becomes the function
used in the first multiApply of the q function.  If we use the 
interpreter, we can see the Type of (multiApply (+2) 3):

   *Main> :t multiApply (+3) 1
   multiApply (+3) 1 :: Num a => a -> a

Since the multiApply function takes a function as its first argument,
this parenthesized function (multiApply f n) returns a function that
is then used in the larger q function's first multiApply.

An example may help to clear this up. Consider the function:

	q (+3) 1 1 1

Replacing the q function with its definition (and labeling the 
parameters, we get:

	multiApply (multiApply (+3) 1) 1 1
	----1----- -------2-------- 3  4 5

The way Haskell evaluates this expression is from left to right. We have
already seen that expression #2 (multiApply (+3) 1) has type:

   multiApply (+3) 1 :: Num a => a -> a

which returns a function a => a -> a.  That function, in turn, is the
first parameter of expression #1 (multiApply). The last two values, #4
and #5, then become the last paramters of the first multiApply function. 

Back to our example:

	q (+3) 1 1 1

this really means "take the function 'add 3 one time' and apply it one
time to the number 1".  Similarly,

	q (+4) 3 2 5

means "take the function 'add 4 three times' and apply it 2 times to 
the number 5".  Doing some quick mental arithmetic, we are adding 12 to
5 two times, which will equal 29.  Checking the results in the 
interpreter shows this to be true:

*Main> q (+4) 3 2 5
29

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
3.  The Haskell prelude includes an operator !! for selecting a numbered
element of the list, with the first element starting at index 0.  For
example, [1..10] !! 0 is 1, while [1..10] !! 7 is 6.  Give a definition
for a Haskell function revindex that performs the same indexing function
as (!!) except that it starts counting from the end of the input list.
For example, revindex [1..10] 0 should return 10, while revindex [1..10] 7
whould return 3.

--------------------------    Answer:   ------------------------------
To reverse the !! operator, we can simply reverse a list, then apply the
!! operator to it.

> revindex :: [a] -> Int -> a
> revindex xs n = reverse xs !! n

Testing:
*Main> revindex [0,1,2,3,4,5] 2
3
*Main> revindex [1,3..99] 6
87
*Main> revindex [1,2,3] 0
3
*Main> revindex [1,2,3] 1
2
*Main> revindex [1,2,3] 2
1
*Main> revindex [1,2,3] 3
*** Exception: Prelude.(!!): index too large

----------------------------------------------------------------------
Question:
----------------------------------------------------------------------
4.  Consider the following fragment of Haskell code:

> strange xs = head (head (reverse (takeWhile notnull (iterate twirl xs))))
> notnull xs = not (null xs)
> twirl xs   = reverse (tail xs)

Explain carefully what the function does.  You may want to type this code in
to a Hugs script and try running tests or using the :t command to provide
clues.  Can you suggest an alternative definition for strange that is more
efficient, more concise, and also easier to understand?

--------------------------    Answer:   ------------------------------
The strange function takes a list as an argument and returns the middle
element of that list (in the case of an odd number of elements) or the 
right-most middle element of a list (in the case of an even number of
elements).

Specifically, it does this by the following methodology:
1. The twirl function takes a list, chops off the first element, reverses
   it, and returns the resulting (shorter by one element) list.
2. The strange function uses twirl on the list, iterating through each
   element, twirling it each time. This has the effect of reversing the
   order and reducing the lenght of the list by one element each time
   through. This returns a list of lists, with each subseqent list 
   shorter by one element than the previous list element.
2. To prevent working on an empty list (and causing an error) strange 
   uses takeWhile notnull to only take the twirled lists that are non
   null.
3. This resulting list is reversed one more time.
4. The head of this list (a list containing one element) is then returned,
   which is then used in the head function to return the first value 
   in the remaining list. This value is the middle element of the 
   original list.

Essentially, this function returns the middle element of a list. This
functionality can be replicated with a much simpler function:

> notSoStrange :: [a] -> a
> notSoStrange xs = xs !! (length xs `div` 2)

Testing:
*Main> strange ["left", "middle", "right"]
"middle"
*Main> strange ["John","Paul","Ringo","George"]
"Ringo"
*Main> strange [1..100]
51

*Main> notSoStrange ["left", "middle", "right"]
"middle"
*Main> notSoStrange ["John","Paul","Ringo","George"]
"Ringo"
*Main> notSoStrange [1..100]
51
----------------------------------------------------------------------
