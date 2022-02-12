# INIT VARIABLES
move_count=0
structure="\
-\t-----------------            \n\
a\t| aa | ab | ac | ad |        \n\
-\t-----------------            \n\
b\t| ba | bb | bc | bd |        \n\
-\t-----------------            \n\
c\t| ca | cb | cc | cd  |       \n\
-\t-----------------            \n\
d\t| da | db | dc | dd |        \n\
-\t-----------------            \n\n\
\t| a | b | c | d |"


# COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
NONE='\033[0m'
# COLOR END



# FUNCTIONS STARTS
# cell max value from cell_info.txt file
function GetCellLimit(){
	local cell=$1
	echo $( grep -i "^$cell" cell_info.txt | cut -d"|" -f2 )
}
# associate cells from cell_info file
function GetAssociateCell(){
	local cell=$1
	echo $( grep -i "^$cell" cell_info.txt | cut -d"|" -f3 )
}


# winner check [ after 2nd move if all colors are some ]
function CheckWinner() {
	#if [[ $move_count -lt 3 ]]; then
	#	return 1
	#fi
	local current_user_color=$1
	local data_file=$2
	opposite_user_color="RED"
	if [[ $current_user_color == "RED" ]] ; then
		opposite_user_color="GREEN"
	fi
	if ! cut -d"|" -f3 "$data_file" | grep -q "$opposite_user_color" ; then
		return 0
	else
		return 1
	fi
}

# updating move and determining if it should start chain reaction or not
function UpdateMove(){
	local cell=$1
	local color=$2
	local file_path=$3
	local unchanged_cell=$( grep -vi "^$cell|" $file_path )
	local changed_cell=$( grep -i "^$cell|" $file_path )
	local changed_cell_val=$( echo "$changed_cell" | cut -d"|" -f2 )
	local cell_limit=$( GetCellLimit "$cell" )
	local chain_reaction="false"
	if [[ $changed_cell_val == $cell_limit ]]; then
		changed_cell_val=0
		color="NONE"
		chain_reaction="true"
	else
	    changed_cell_val=$(( $changed_cell_val + 1 ))
    fi
    echo "$unchanged_cell" > $file_path
    echo "$cell|$changed_cell_val|$color" >> $file_path
	echo $chain_reaction
}

# initiating moving and checking for winner
function InitiateMove(){
	clear
	local choice=$1
	local current_player_color=$2
	local asso_cells=$( GetAssociateCell "$choice" )
	if [[ $move_count -gt 2 ]]; then
		if CheckWinner $current_player_color "./status.txt" ; then
			return 100
		fi
	fi
	local chain_reaction=$( UpdateMove $choice $current_player_color "./status.txt" )
	DisplayStructure
	if [[ $chain_reaction == "true" ]]; then
#		sleep 1
		for asso_cell in $asso_cells; do
			InitiateMove $asso_cell $current_player_color
		done
	fi
}


# validating move
function ValidateMove(){
	local cell=$1
	local color=$2
	if echo $cell | grep -q "^[a-z][a-z]" && grep -q "^$cell" cell_info.txt ; then
		local cell_current_color=$( grep "^$cell" status.txt | cut -d"|" -f3 )
		if [[ $cell_current_color == $color || $cell_current_color == "NONE" ]]; then
			move_count=$(( $move_count + 1))
			return 0
		fi
	fi
	return 1
}


# display structure in the terminal
function DisplayStructure(){
	updated_structure=$( echo $structure )
	for status in `cat status.txt`
	do
		local cell_name=$( echo "$status" | cut -d"|" -f1 )
		local cell_status=$( echo "$status" | cut -d"|" -f2 )
		local cell_color=$( echo "$status" | cut -d"|" -f3 )
		local replace_with=""
		if [[ $cell_color == "RED" ]]
		then
			replace_with="${RED}${cell_status}${NONE}"
		elif [[ $cell_color == "GREEN" ]]
		then
			replace_with="${GREEN}${cell_status}${NONE}"
		elif [[ $cell_color == "NONE" ]]
		then
			replace_with="${NONE}${cell_status}${NONE}"
		else
			replace_with=$cell_color
		fi
		updated_structure=$( echo ${updated_structure/$cell_name/$replace_with} )
	done

	echo -e "${updated_structure}"
}

#FUNCTIONS ENDS

