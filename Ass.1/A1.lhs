----------------------------------------------------------------------
CS457/557 Functional Languages, Winter 2014                 Homework 1
----------------------------------------------------------------------

Due: At the start of class (10am) on January 16, 2014 in person, or by
the same time if you submit by email or D2L.

To complete this set of homework exercises, you may need to use or know
about the following small collection of Haskell prelude functions that
have not yet been discussed in class:

- null :: [a] -> Bool   returns True if it is applied to an empty
  list and False otherwise.  For example null [] is True, while
  null [1,2,3] is False.

- head :: [a] -> a returns the first value in a nonempty list.  For
  example, head [1,2,3,4] is 1.

- tail :: [a] -> [a] returns the input list but with its first element
  removed.  For example, tail [1,2,3,4] is [2,3,4].

- takeWhile :: (a -> Bool) -> [a] -> [a], returns all of the values at
  the front of the input list that satisfy the predicate argument.
  For example, takeWhile even [2,4,8,11,12,20] returns [2,4,8].
  while takeWhile even [1..10] returns [].

----------------------------------------------------------------------
Question:
1. Explain what the following Haskell function does:

> dup    :: (a -> a -> a) -> a -> a
> dup f x = f x x

Answer:
The dup function takes a function and a single argument and returns
the value of the function with the argument duplicated.

----------------------------------------------------------------------
Question:
Now Consider the following two functions, and show how each of them
can be rewritten using dup:

double  :: Integer -> Integer
double n = 2 * n

square  :: Integer -> Integer
square n = n * n

Answer:
The previous functions can use the dup function as written below. Since
the dup function duplicates the arguments of a function, it can be used
in functions that use a given argument twice, such as squaring or 
doubling a number.

> double :: Integer -> Integer
> double n = dup (+) n

> square :: Integer -> Integer
> square n = dup (*) n

----------------------------------------------------------------------
Question:
2. Without using any explicit recursion, given Haskell definitions for
the following functions:

- powerOfTwo :: Int -> Integer
  (powerOfTwo n) returns the value of 2 to the power n.  For example,
  powerOfTwo 8 should return 256.  Of course, your answer should *not*
  use the built in Haskell functions for raising a value to a power :-)

Answer:
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

----------------------------------------------------------------------
Question:
- logTwo :: Integer -> Int
  (logTwo v) returns the smallest integer n such that v < powerOfTwo n.

Answer:
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

----------------------------------------------------------------------
Question:
- copy :: Int -> a -> [a]
  (copy n x) returns a list containing n copies of the value x.  For
  example, copy 3 True should give [True, True, True].  (The Haskell
  prelude includes a similar function called replicate; of course,
  you should not use replicate in your answer; you should not replicate
  replicate either :-)

Answer:
This version of copy uses the repeat prelude function to build an 
infinitely long list of repeating values, then takes the first n
values in that list.

> copy :: Int -> a -> [a]
> copy n x = take n (repeat x)

----------------------------------------------------------------------
Question:
- multiApply :: (a -> a) -> Int -> a -> a
  (multiApply f n x)  returns the value that is obtained when the
  function f is applied n times to the value x.  For example,
  multiApply square 2 2, should return 16, while
  multiApply not 0 True will return True.

Answer:
To apply a function multiple times, one can employ the iterate function.
The iterate function applies a function to a starting value and repeats
indefinitely. By choosing some defined element of the resulting list, 
using the !! operator, we can implement multiApply.

> multiApply :: (a -> a) -> Int -> a -> a
> multiApply f n x = (iterate f x ) !! n

Question:
Now suppose that we define the following function using multiApply:

> q f n m x = multiApply (multiApply f n) m x

What is the type of this function, and what exactly does it do?

Answer:
the q function is of type a, the polymorphic type. It applies to any
Haskell primitive type or user-defined type. To test this, I ran the
following command:

:t q

which returns

q :: (a -> a) -> Int -> Int -> a -> a

So the q function is of a generic, polymorphic type. It can return any
type of value, depending on what type of values are passed into it
as a list.







----------------------------------------------------------------------
Question:
3.  The Haskell prelude includes an operator !! for selecting a numbered
element of the list, with the first element starting at index 0.  For
example, [1..10] !! 0 is 1, while [1..10] !! 7 is 6.  Give a definition
for a Haskell function revindex that performs the same indexing function
as (!!) except that it starts counting from the end of the input list.
For example, revindex [1..10] 0 should return 10, while revindex [1..10] 7
whould return 3.

Answer:
To reverse the !! operator, we can simply reverse a list, then apply the
!! operator to it.

> revindex :: [a] -> Int -> a
> revindex xs n = reverse xs !! n

----------------------------------------------------------------------
Question:
4.  Consider the following fragment of Haskell code:

> strange xs = head (head (reverse (takeWhile notnull (iterate twirl xs))))
> notnull xs = not (null xs)
> twirl xs   = reverse (tail xs)

Explain carefully what the function does.  You may want to type this code in
to a Hugs script and try running tests or using the :t command to provide
clues.  Can you suggest an alternative definition for strange that is more
efficient, more concise, and also easier to understand?

Answer:
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

----------------------------------------------------------------------
