import Data.Array (Array, array)
import Data.Word (Word8)

main :: IO ()
main = do
    putStrLn "Hello, world!"

interpret :: String -> State -> State
interpret 

processInstruction :: Char -> State -> State
processInstruction = 

movePointerRight :: State -> Either State String
movePointerRight s =
    if pCurr == 0
        then Left (s { pData = (pData s) + 1 })
        else Right "
    where pCurr = pData s

movePointerLeft :: State -> State

incrementAtPointer :: State -> State

decrementAtPointer :: State -> State

printCharAtPointer :: State -> State

storeInputAtPointer :: State -> State

JumpBackwards :: State -> State

JumpForwards :: State -> State

initialState :: String -> State
initialState instructions = State
    { dataTape = array (0, 30_000) []
    , pData = 0
    , instructionTape = array (0, length str) []
    }

type State = State
    { dataTape :: Array Int Int
    , pData :: Int
    , instructionTape :: Array Int Char
    , pInst :: Int
    }

