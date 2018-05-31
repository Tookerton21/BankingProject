{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative
import           Data.Int (Int64)
import           Data.Text (Text)
import qualified Data.Text as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow
import Control.Monad

data User =
  User
  { id        :: Int64
  , fname     :: Text
  , lname     :: Text
  , checking  :: Double
  , savings   :: Double
  } deriving (Eq, Read, Show)



instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field <*> field

instance ToRow User where
  toRow (User id_ fName lName c s) = toRow(fName, lName, c, s)

data UserField = UserField Int T.Text T.Text Int Int deriving (Show)
instance FromRow UserField where
  fromRow = UserField <$> field <*> field <*> field <*> field <*> field
instance ToRow UserField where
  toRow (UserField id_ fname lname checking savings) = toRow (id_, fname, lname, checking, savings)

data Sav = Sav Integer deriving (Show)
instance FromRow Sav where
  fromRow = Sav <$> field

instance FromRow Int where
  fromRow = field


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
  close conn
{-
  Remove a user from the database base. Uses the usersId to delete them
-}
removeUser :: Int -> IO ()
removeUser userId = do
  conn <- open "Bank.db"
  execute conn "DELETE FROM users WHERE id = ?" (Only userId)
  close conn

{-
 Modify a users Savings with the parameter passed in amnt. Must pass the users Id
 to make the modification.
-}
modSavings  :: Int -> Double -> IO ()
modSavings userId amnt = do
  conn <- open "Bank.db"
  executeNamed conn "UPDATE users SET savings = :savings WHERE id = :id" [":savings" := amnt, ":id" := userId]
  close conn
{-
  Modify a users checking to the parameter passed in as amnt. Must pass in the users
  Id to make the modification
-}
modChecking  :: Int -> Double -> IO ()
modChecking userId amnt = do
  conn <- open "Bank.db"
  executeNamed conn "UPDATE users SET checking = :checking WHERE id = :id" [":checking" := amnt, ":id" := userId]
  close conn
