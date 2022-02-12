# removing previous game file if have
if [[ -f status.txt ]]; then
	rm status.txt
fi
if [[ -f cell_info.txt ]]; then
	rm cell_info.txt
fi


# using other files functions
source initiate_files.sh
source main.sh


# initiating nessesary files
InitiateCellInfoFile
InitiateStatusFile
# initiate done


function play_round(){
	user=$1
	echo -en "\n$user's move : "
	read move
	if ValidateMove $move $user ; then
		InitiateMove $move $user
		exit_status=$?
		return $exit_status
	else
		# this is a invaild move, so we are starting the round again with same user
		echo "Invaild Move"
		play_round $user
	fi
}

current_user="RED"
echo "Welcome to chain reaction"
DisplayStructure

while true
do
	play_round $current_user
	round_status=$?
	if [[ $round_status == 100 ]]; then
		echo "Congrats $current_user !! You are the winner"
		DisplayStructure
		break
	fi
	if [[ $current_user == "RED" ]]; then
		current_user="GREEN"
	else
		current_user="RED"
	fi
done

