{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative
import qualified Data.Text as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow
import Control.Monad

data TestField = TestField Int T.Text T.Text deriving (Show)

data UserField = UserField Int T.Text T.Text Int Int deriving (Show)
instance FromRow UserField where
  fromRow = UserField <$> field <*> field <*> field <*> field <*> field
instance ToRow UserField where
  toRow (UserField id_ fname lname checking savings) = toRow (id_, fname, lname, checking, savings)

data Sav = Sav Integer deriving (Show)
instance FromRow Sav where
  fromRow = Sav <$> field

-- instance ToRow Sav where
--  toRow (Sav savings) = toRow (savings)

instance FromRow TestField where
  fromRow = TestField <$> field <*> field  <*> field

instance ToRow TestField where
  toRow (TestField id_ str str2) = toRow (id_, str, str2)

{-
main :: IO ()
main = do
  conn <- open "test.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, str TEXT, str2 Text)"
  let strf = "fname"::String
  let strn = "lname"::String
  execute conn "INSERT INTO test (str, str2) VALUES (?, ?)"
               [strf, strn]
  --execute conn "INSERT INTO test (id, str) VALUES (?,?)" (TestField 13 "test string 3")
  --rowId <- lastInsertRowId conn
  --executeNamed conn "UPDATE test SET str = :str WHERE id = :id" [":str" := ("updated str" :: T.Text), ":id" := rowId]
  r <- query_ conn "SELECT * from test" :: IO [TestField]
  mapM_ print r
  -- execute conn "DELETE FROM test WHERE id = ?" (Only rowId)
  close conn
-}

--  display UserData
displayUser = do
  conn <- open "Bank.db"
  r <- query_ conn "SELECT * from users" :: IO[UserField]
  mapM_ print r

-- Add a user to the database
addUser = do
  conn <- open "Bank.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS users (id Integer PRIMARY KEY, fName TEXT, lName TEXT, checking INTEGER, savings INTEGER)"

  putStrLn "Enter First Name: "
  fname <- getLine
  putStrLn "Enter Last Name: "
  lname <- getLine
  let c = 0 :: Integer
  let s = 0 :: Integer

  execute conn "INSERT INTO users (fName, lName, checking, savings) VALUES (?,?,?,?)"
               (fname, lname, c, s)

  r <- query_ conn "SELECT * from users" :: IO [UserField]
  mapM_ print r
  close conn

-- Removing a user from the database
removeUser = do
  conn <- open "Bank.db"

  putStrLn "What user whould you like to remove"
  putStrLn "Enter id: "
  userId <- getLine

  --r <- query_ conn "SELECT * from users" :: IO [TestField]
  --mapM_ print r

  execute conn "DELETE FROM users WHERE id = ?" (Only userId)

  r <- query_ conn "SELECT * from users" :: IO [UserField]
  mapM_ print r


 --modSavings amnt acntNum = do

{-
testQuery = do
  conn <- open "Bank.db"
  putStrLn "Enter User Id: "
  userId <- getLine
  r <- queryNamed conn "SELECT savings FROM users WHERE id = :id" [":id" := userId]
  -- forM_ r $ \(savings)->
  putStrLn "done"
-}
--  xs <- query_ conn "select fName,savings from users"
--  forM_ xs $ \(fName,savings) ->
--    putStrLn $ T.unpack fName ++ " is " ++ show (savings :: Int)
   --old <- execute conn "Select savings from users where id = ?" (Only acntNum)

--  putStrLn (read old)
  -- execute conn "Modify"
