# ISSUES

0. complete() should not generate a textchanged/moved so no recursion occurs
1. on textchanged/cursormoved going back should not trigger again
2. buffer should only update if textchanged not inside a word, so no partial
   words inserted
3. 
