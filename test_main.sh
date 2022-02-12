source main.sh

function verify_expectation(){
	local actual_output=$1
	local expected_output=$2
	local inputs=$3
	local outputs="actual_output : $actual_output, expected_output : $expected_output"
	local test_result="FAIL"
	if [[ $actual_output == $expected_output ]]; then
		test_result="PASS"
	fi
	echo "${test_result}	INPUTS : ${inputs}, 	OUTPUTS : ${outputs}"
}

function test_GetCellLimit(){
	local cell=$1
	local expected_output=$2
	local actual_output=$( GetCellLimit $cell )
	local inputs="Cell : $cell"
	verify_expectation "$actual_output" "$expected_output" "$inputs"
}

function GetCellLimit_testcases(){
	echo -e "Testing getCellLimit\n---"
    test_GetCellLimit "aa" "1"
    test_GetCellLimit "ab" "2"
    test_GetCellLimit "cc" "3"
    test_GetCellLimit "da" "1"

}

function test_GetAssociateCell(){
	local cell=$1
	local expected_output=$2
	local actual_output=$( GetAssociateCell $cell )
	local inputs="Cell : $cell"
	verify_expectation "$actual_output" "$expected_output" "$inputs"
}

function GetAssociateCell_testcases(){
	echo -e "\nTesting GetAssociateCell\n---"
    test_GetAssociateCell "aa" "ba ab"
    test_GetAssociateCell "bb" "ab cb ba bc"
    test_GetAssociateCell "dd" "cd dc"
}

function test_CheckWinner(){
	local current_player=$1
	local data_file=$2
	local expected_output=$3
	local actual_output=0
	CheckWinner $current_player $data_file
	actual_output=$?
	local inputs="current_player : $current_player, data_file : $data_file"
	verify_expectation "$actual_output" "$expected_output" "$inputs"
}

function CheckWinner_testcases(){
	echo -e "\nTesting CheckWinner Function\n---"
    test_CheckWinner "GREEN" "./test_files/test_status_no_winner.txt" "1"
    test_CheckWinner "GREEN" "./test_files/test_status_green_winner.txt" "0"
    test_CheckWinner "RED" "./test_files/test_status_red_winner.txt" "0"
}

function test_UpdateMove(){
	local cell=$1
	local color=$2
	local expected_outout=$3
	local actual_output=""
	UpdateMove $cell $color $status_file_path
	actual_output=$?
	local inputs="cell : ${cell}, color : ${color}, path : ${path}"
	verify_expectation "$actual_output" "$expected_output" "$inputs"
}

function UpdateMove_testcases(){
	echo -e "\nTesting UpdateMove Function\n---"
	test_UpdateMove "aa" "RED" "./test_files/test_status_chain_reaction_true.txt"
	test_UpdateMove "aa" "RED" "./test_files/test_status_chain_reaction_false.txt"
}
#GetCellLimit_testcases
#GetAssociateCell_testcases
#CheckWinner_testcases


