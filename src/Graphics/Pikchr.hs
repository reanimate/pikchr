module Graphics.Pikchr where

import Foreign.C (CString,CInt(..))
import Foreign.Ptr
-- import Foreign.C.String
import Foreign.Marshal.Alloc ( free )
import System.IO.Unsafe
import Data.Text.Encoding
import Data.Text
import Data.ByteString
import qualified Data.Text.IO as T

foreign import ccall "pikchr" pikchr_c :: CString -> CString -> CInt -> Ptr CInt -> Ptr CInt -> IO CString
{-
char *pikchr(
  const char *zText,     /* Input PIKCHR source text.  zero-terminated */
  const char *zClass,    /* Add class="%s" to <svg> markup */
  unsigned int mFlags,   /* Flags used to influence rendering behavior */
  int *pnWidth,          /* Write width of <svg> here, if not NULL */
  int *pnHeight          /* Write height here, if not NULL */
-}

pikchr :: Text -> Text
pikchr txt = unsafePerformIO $ useAsCString (encodeUtf8 txt) $ \c_txt -> do
  ret <- pikchr_c c_txt nullPtr 0 nullPtr nullPtr
  svg <- packCString ret
  free ret
  return $ decodeUtf8 svg
