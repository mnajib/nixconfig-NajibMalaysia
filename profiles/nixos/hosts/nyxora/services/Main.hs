-- File: profiles/nixos/hosts/nyxora/services/Main.hs
--
-- Haskell Scotty Web Application for Local Services Dashboard
--

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Main (main) where

import Data.FileEmbed (embedStringFile)
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as TL
import Web.Scotty

-- | Embed index.html at compile-time as a lazy Text constant
dashboardHtml :: Text
dashboardHtml = TL.pack $(embedStringFile "index.html")

main :: IO ()
main = scotty 8081 $ do
  get "/" $ do
    html dashboardHtml
