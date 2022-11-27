#!/bin/bash

if [[ $USER_SHELL == *"/bash"*  ]] || [[ $USER_SHELL == *"/zsh"*  ]] || [[ $USER_SHELL == *"/sh"*  ]]; then
      echo "1"
 else
    echo "2"
fi
