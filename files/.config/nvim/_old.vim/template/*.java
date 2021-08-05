/*
 * File:   ${expand("%:p")}
 * Author: ${expand("$USER")}
 * Email:  ${$USER . "@" . hostname()}
 * Date:   ${strftime("%c")}
 */
${ java#package(expand("%:p:h")) != "" ? ("package " . java#package(expand("%:p:h")) . ";") : ""}

public class ${substitute(expand("%:p:t:r"), '[a-z]', '\U&', '')} {

}
