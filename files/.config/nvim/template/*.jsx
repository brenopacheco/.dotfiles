/*
 * File:   ${expand("%:t")}
 * Author: ${expand("$USER")}
 * Email:  ${$USER . "@" . hostname()}
 * Date:   ${strftime("%c")}
 */
import React from 'react'

export default class ${expand('%:p:t:r')} extends React.Component {
    render() {
        return (
            <React.Fragment>

            </React.Fragment>
        )
    }
}


/* vim: set ft=javascriptreact */
