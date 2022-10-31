module ProjectsSpec where

import           Projects.Domain.Project (mkProject)

import           Data.Either             (isLeft, isRight)
import           Data.Text               (Text)
import           Test.Hspec

testTitle :: Text
testTitle = "Some title"

testDesc :: Text
testDesc = "Some description"

testUri :: Text
testUri = "https://github.com"

spec :: Spec
spec = do
  describe "The Project entity" $ do
    it "Fails to validate an empty title" $
      mkProject "" testDesc testUri `shouldSatisfy` isLeft

    it "Fails to validate a blank title" $ do
      mkProject "    " testDesc testUri `shouldSatisfy` isLeft

    it "Fails to validate an empty description" $
      mkProject testTitle "" testUri `shouldSatisfy` isLeft

    it "Fails to validate an empty uri" $
      mkProject testTitle testDesc "" `shouldSatisfy` isLeft

    it "Can validate well formed input" $
      mkProject testTitle testDesc testUri `shouldSatisfy` isRight
