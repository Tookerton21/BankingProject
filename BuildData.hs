{-# LANGUAGE OverloadedStrings #-}

module BuildData where
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

data UserField = UserField Int T.Text T.Text Double Double deriving (Show)

instance FromRow UserField where
  fromRow = UserField <$> field <*> field <*> field <*> field <*> field
instance ToRow UserField where
  toRow (UserField id_ fname lname checking savings) = toRow (id_, fname, lname, checking, savings)

instance FromRow Int where
  fromRow = field

instance FromRow Double where
  fromRow = field

{-
  Displays all the users in THe dataBase
-}
displayUsers = do
  conn <- open "Bank.db"
  r <- query_ conn "SELECT * from users" :: IO[UserField]
  close conn
  mapM_ print r
{-
  Display A User's information in the dataBase
-}
displayUser userId = do
  conn <-open "Bank.db"
  [amt] <- query conn "SELECT * from users where id=?" (Only userId) :: IO [UserField]
  close conn
  print amt

{-
  Create a user based onthe parameters that are passed in, first and last name.
  This function will create a Table for the users if the table doesnt exist yet otherwise
  It will append to the table. Will initialize the checking and savings to 0.
-}
addUser firstN lastN checkingAmout savingAmount = do
  conn <- open "Bank.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS users (id Integer PRIMARY KEY, fName TEXT, lName TEXT, checking DOUBLE, savings DOUBLE)"
  execute conn "INSERT INTO users (fName, lName, checking, savings) VALUES (?,?,?,?)"
                (firstN, lastN, checkingAmout, savingAmount)
  close conn;

{-
addUser = do
  conn <- open "Bank.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS users (id Integer PRIMARY KEY, fName TEXT, lName TEXT, checking DOUBLE, savings DOUBLE)"

  putStrLn "Enter First Name: "
  fname <- getLine
  putStrLn "Enter Last Name: "
  lname <- getLine
  let c = 0 :: Double
  let s = 0 :: Double

  execute conn "INSERT INTO users (fName, lName, checking, savings) VALUES (?,?,?,?)"
               (fname, lname, c, s)
  close conn
-}
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
-- modChecking  :: Int -> Double -> IO ()
modChecking userId amnt = do
  conn <- open "Bank.db"
  executeNamed conn "UPDATE users SET checking = :checking WHERE id = :id" [":checking" := amnt, ":id" := userId]
  close conn

getUserId :: [Char] -> [Char] -> IO Int
getUserId fname lname = do
  conn <- open "Bank.db"
  [id] <- query conn "SELECT id from users where fname = ? and lname = ?" (fname::String, lname::String) :: IO [Int]
  close conn
  return id

-- getSavings :: Int -> IO Int
getSavings userId = do
  conn <- open "Bank.db"
  [amt] <- query conn "SELECT savings from users where id=?" (Only userId) :: IO [Double]
  close conn
  return amt

-- getChecking :: Int -> IO Double
getChecking userId = do
  conn <- open "Bank.db"
  [amt] <- query conn "SELECT checking from users where id=?" (Only userId) :: IO [Double]
  close conn
  return amt


--getCheckingTest :: Int -> IO Float
--getCheckingTest userId = do
--  conn <- open "Bank.db"
--  [amt] <- query conn "SELECT checking from users where id=?" (Only userId) :: IO [Float]
--  close conn
--  return amt
