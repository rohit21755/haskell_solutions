module Set11b where

import Control.Monad
import Data.List
import Data.IORef
import System.IO

import Mooc.Todo


------------------------------------------------------------------------------
-- Ex 1: Given an IORef String and a list of Strings, update the value
-- in the IORef by appending to it all the strings in the list, in
-- order.
--
-- Example:
--   *Set11b> r <- newIORef "x"
--   *Set11b> appendAll r ["foo","bar","quux"]
--   *Set11b> readIORef r
--   "xfoobarquux"

appendAll :: IORef String -> [String] -> IO ()
appendAll ref strings = modifyIORef' ref (\x -> x ++ concat strings)

------------------------------------------------------------------------------
-- Ex 2: Given two IORefs, swap the values stored in them.
--
-- Example:
--   *Set11b> x <- newIORef "x"
--   *Set11b> y <- newIORef "y"
--   *Set11b> swapIORefs x y
--   *Set11b> readIORef x
--   "y"
--   *Set11b> readIORef y
--   "x"

swapIORefs :: IORef a -> IORef a -> IO ()
swapIORefs ref1 ref2 = do
    value1 <- readIORef ref1
    value2 <- readIORef ref2
    writeIORef ref1 value2
    writeIORef ref2 value1

------------------------------------------------------------------------------
-- Ex 3: sometimes one bumps into IO operations that return IO
-- operations. For instance the type IO (IO Int) means an IO operation
-- that returns an IO operation that returns an Int.
--
-- Implement the function doubleCall which takes an operation op and
--   1. runs op
--   2. runs the operation returned by op
--   3. returns the value returned by this operation
--
-- Examples:
--   - doubleCall (return (return 3)) is the same as return 3
--
--   - let op :: IO (IO [String])
--         op = do l <- readLn
--                 return $ replicateM l getLine
--     in doubleCall op
--
--     works just like
--
--     do l <- readLn
--        replicateM l getLine

doubleCall :: IO (IO a) -> IO a
doubleCall io = io >>= id

------------------------------------------------------------------------------
-- Ex 4: implement the analogue of function composition (the (.)
-- operator) for IO operations. That is, take an operation op1 of type
--     a -> IO b
-- an operation op2 of type
--     c -> IO a
-- and a value of type
--     c
-- and returns an operation op3 of type
--     IO b
--
-- op3 should of course
--   1. take the value of type c and pass it to op2
--   2. take the resulting value (of type a) and pass it to op1
--   3. return the result (of type b)

compose :: (a -> IO b) -> (c -> IO a) -> c -> IO b
compose op1 op2 c = op2 c >>= op1

------------------------------------------------------------------------------
-- Ex 5: Reading lines from a file. The module System.IO defines
-- operations for Handles, which represent open files that can be read
-- from or written to. Here are some functions that might be useful:
--
-- * hGetLine :: Handle -> IO String
--   Reads one line from the Handle. Will fail if the Handle is at the
--   end of the file
-- * hIsEOF :: Handle -> IO Bool
--   Produces True if the Handle is at the end of the file.
-- * hGetContents :: Handle -> IO String
--   Reads content from Handle until the end of the file.
--
-- Implement the function hFetchLines which returns the contents of
-- the given handle as a sequence of lines.
--
-- There are multiple ways to implement this function. You can either
-- read the lines one by one, or read the whole file and then worry
-- about splitting lines. Both approaches are fine, and you can even
-- try out both!
--
-- Example:
--   *Set11b> h <- openFile "Set11b.hs" ReadMode
--   *Set11b> ls <- hFetchLines h
--   *Set11b> take 3 ls
--   ["module Set11b where","","import Control.Monad"]

hFetchLines :: Handle -> IO [String]
hFetchLines h = hGetContents h >>= return . lines

------------------------------------------------------------------------------
-- Ex 6: Given a Handle and a list of line indexes, produce the lines
-- at those indexes from the file.
--
-- Line indexing starts from 1.
--
-- Here too, there are multiple ways to implement this. You can try
-- using hFetchLines, or writing out a loop that gets lines from the
-- handle.

hSelectLines :: Handle -> [Int] -> IO [String]
hSelectLines h nums = do
    lines <- hFetchLines h
    return $ map (\n -> lines !! (n - 1)) nums

------------------------------------------------------------------------------
-- Ex 7: In this exercise we see how a program can be split into a
-- pure part that does all of the work, and a simple IO wrapper that
-- drives the pure logic.
--
-- Implement the function interact' that takes a pure function f of
-- type
--   (String, st) -> (Bool, String, st)
-- and a starting state of type st and returns an IO operation of type
-- IO st
--
-- interact' should read a line from the user, feed the line and the
-- current state to f. f then returns a boolean, a string to print and
-- a new state. The string is printed, and if the boolean is True, we
-- continue running with the new state. If the boolean is False, the
-- execution has ended and the state should be returned.
--
-- Example:
--   *Set11b> interact' counter 1
--   print
--   1
--   inc
--   done
--   inc
--   done
--   print
--   3
--   quit
--   bye bye
--   3
--   *Set11b>

-- This is used in the example above. Don't change it!
interact' :: ((String, st) -> (Bool, String, st)) -> st -> IO st
interact' f st = do
    putStrLn "Enter a command:"
    input <- getLine
    let (continue, output, newState) = f (input, st)
    putStrLn output
    if continue
        then interact' f newState
        else return newState
