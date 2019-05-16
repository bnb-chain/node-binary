#!/bin/bash

####### convert number to english
digits=(
    "" one two three four five six seven eight nine
    ten eleven twelve thirteen fourteen fifteen sixteen seventeen eightteen nineteen
)
tens=("" "" twenty thirty forty fifty sixty seventy eighty ninety)
units=("" thousand million billion trillion)

function number2words() {
    local -i number=$((10#$1))
    local -i u=0
    local words=()
    local group

    while ((number > 0)); do
        group=$(hundreds2words $((number % 1000)) )
        [[ -n "$group" ]] && group="$group ${units[u]}"

        words=("$group" "${words[@]}")

        ((u++))
        ((number = number / 1000))
    done
    echo "${words[*]}"
}

function hundreds2words() {
    local -i num=$((10#$1))
    if ((num < 20)); then
        echo "${digits[num]}"
    elif ((num < 100)); then
        echo "${tens[num / 10]} ${digits[num % 10]}"
    else
        echo "${digits[num / 100]} hundred $("$FUNCNAME" $((num % 100)) )"
    fi
}
####### convert number to english

testnet_chain_id="Binance-Chain-Nile"
testnet_node="http://data-seed-pre-0-s3.binance.org:80"

mainnet_chain_id="Binance-Chain-Tigris"
mainnet_node="http://dataseed1.binance.org:80"

testnet_bnbcli="./tbnbcli"
mainnet_bnbcli="./bnbcli"

while true; do
    echo "Do you want to send transaction to testnet or mainnet?"
    echo "1 for testnet"
    echo "2 for mainnet"

    read env

    case ${env} in
        [1] )
            echo "Ok, you choose testnet"
            chain_id=${testnet_chain_id}
            node=${testnet_node}
            bnbcli=${testnet_bnbcli}
            break;;
        [2] )
            echo "Ok, you choose mainnet"
            chain_id=${mainnet_chain_id}
            node=${mainnet_node}
            bnbcli=${mainnet_bnbcli}
            break;;
        * ) echo 'Please input 1 or 2';;
    esac
done

if [[ ! -f "${bnbcli}" ]]; then
	echo "bnbcli does not exist!"
	exit 1
fi

# Get account type
while true; do
    echo "Will you use Ledger or local key store to sign the transactions?"
    echo "1 for Ledger"
    echo "2 for Local Key store"

    read account_type

    case ${account_type} in
        [1] )
            echo "Ok, you choose Ledger"
            break;;
        [2] )
            echo "Ok, you choose Local Key Store"
            break;;
        * ) echo 'Please input 1 or 2';;
    esac
done

# Get cli home
while true; do
    echo "Where is your bnbcli home?(default is ~/.bnbcli, just press enter if you want to use default)"
    read bnbcli_home
    if [[ "${bnbcli_home}" == "" ]]
    then
        bnbcli_home="${HOME}/.bnbcli"
        echo "You choose default home!"
    fi

    if [[ ! -d "$bnbcli_home" ]]; then
	    echo "bnbcli home(${bnbcli_home}) does not exist!"
        continue
    fi

    if [[ ${account_type} == "1" ]]
    then
        accounts=$(echo "$(${bnbcli} keys list )" | grep ledger)
        if [[ "${accounts}" == "" ]]
        then
            echo "No account exists there"
            continue
        fi
        echo "${accounts}"
    else
        accounts=$(echo "$(${bnbcli} keys list )" | grep local)
        if [[ "${accounts}" == "" ]]
        then
            echo "No account exists there"
            continue
        fi
        echo "${accounts}"
    fi
    break
done

# Get account name
while true; do
    echo "Which account do you want to use?"
    read account_name
    if [[ "${account_name}" == "" ]]
    then
        echo "Please input account name"
        continue
    fi

    result=$(echo "${accounts}" | awk '{print $1}' | grep "^${account_name}$")
    if [[ "${result}" == "" ]]
    then
        echo "${account_name} does not exist"
        continue
    fi
    break
done

# Get token name
while true; do
    echo "What is the token name? (Token name should only contain less than 33 alphanumeric characters and space)"
    read token_name

    result=$(echo ${token_name} | grep "^[0-9|a-z|A-Z| ]\{1,32\}$")
    if [[ "$result" == "" ]]
    then
        echo "Token name should only contain less than 33 alphanumeric characters and space, please try again."
        continue
    else
        break
    fi
done

# Get symbol
while true; do
    echo "What is the symbol? (Symbol should only contain 3~8 alphanumeric characters)"
    read symbol

    result=$(echo ${symbol} | grep "^[0-9|a-z|A-Z]\{3,8\}$")
    if [[ "$result" == ""  ]]
    then
        echo "Symbol should only contain 3~8 alphanumeric characters, please try again."
        continue
    else
        symbol=$(echo ${symbol} | tr a-z A-Z)
        break
    fi
done

# Get supply
while true; do
    echo "What is the actual total supply? (Supply should be larger than 1000 and less than 90000000000)"
    read supply

    result=$(echo ${supply} | grep "^[1-9][0-9]*$")
    if [[ "$result" == ""  ]]
    then
        echo "Supply should only contain numeric characters."
        continue
    fi

    if [[ $((supply)) -lt 1000 || $((supply)) -gt 90000000000 ]]
    then
        echo "Supply should be larger than 1000 and less than 90000000000."
    fi

    english_version=$(number2words ${supply})
    echo "Total supply is ${english_version}(${supply}), which will be shown as ${supply}00000000 in command, enter Y to continue, enter other key to input again."
    read retry
    case ${retry} in
        [Yy] )
            break;;
        * )
            continue;;
    esac
done

# Get mintable
while true; do
    echo "Is the token mintable? [Y or N]"
    read mintable

    case ${mintable} in
        [Yy] )
            mintable="true"
            break;;
        [Nn] )
            mintable="false"
            break;;
        * ) echo 'Please answer yes or no: ';;
    esac
done

command="${bnbcli} token issue -s ${symbol} --token-name \"${token_name}\" --total-supply ${supply}00000000 --from ${account_name} --mintable=${mintable} --chain-id ${chain_id} --node=${node}"
echo "Below is the command to be executed:"
echo "*****************************************************"
echo ${command}
echo "*****************************************************"
echo "Enter Y to execute or enter N to abort."
while true; do
    read execute

    case ${execute} in
        [Yy] )
            ${bnbcli} token issue -s ${symbol} --token-name "${token_name}" --total-supply ${supply}00000000 --from ${account_name} --mintable=${mintable} --chain-id ${chain_id} --node=${node}
            break;;
        [Nn] )
            exit
            break;;
        * ) echo 'Please input Y or N';;
    esac
done

