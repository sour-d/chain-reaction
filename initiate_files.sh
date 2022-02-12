# INIT VARIABLES
total_col=4
total_row=4
# INIT VARIABLES ENDS


# FUNCTIONS STARTS
# number to alpha
function NumberToAlpha(){
	local number=$1
	local alpha=$( echo $number | tr "[:digit:]" "[:alpha:]" | tr "[:upper:]" "[:lower:]" )
	echo $alpha
}

# row and col number to alphabet ; like 1 2 is'ab'
function NumberToCellName(){
	local row_num=$1
	local col_num=$2
	local row_alpha=$( NumberToAlpha $row_num )
	local col_alpha=$( NumberToAlpha $col_num )
	local cell="${row_alpha}${col_alpha}"
	echo $cell
}


# Each cell max value
function CellMaxValue(){
	local row_num=$1
	local col_num=$2
	local cell_value=3
	if [[ $row_num == 0 || $row_num == $(( $total_row - 1 )) ]] && [[ $col_num == 0  || $col_num == $(( $total_col - 1 )) ]]; then
		cell_value=1
	elif [[ $row_num == 0 || $row_num == $(( $total_row - 1 )) || $col_num == 0 || $col_num == $(( $total_col - 1 )) ]]; then
		cell_value=2
	fi

	echo $cell_value
}

# associate cells to a cell
function AssociateCell(){
	local row=$1
	local col=$2
	local up_row=$(( $row - 1 ))
	local down_row=$(( $row + 1 ))
	local left_col=$(( $col - 1 ))
	local right_col=$(( $col + 1 ))
	local associate_cell=""

	if (( $row == 0 && $col == 0 )); then
		associate_cell=$( NumberToCellName $down_row $col )" "$( NumberToCellName $row $right_col )

	elif [[ $row == 0 && $col == $(( $total_col - 1 )) ]]; then
		associate_cell=$( NumberToCellName $down_row $col )" "$( NumberToCellName $row $left_col )

	elif (( $row == $(( $total_row - 1 )) && $col == 0 )); then
		associate_cell=$( NumberToCellName $up_row $col )" "$( NumberToCellName $row $right_col )

	elif (( $row == $(( $total_row - 1 )) && $col == $(( $total_col - 1 )) )); then
		associate_cell=$( NumberToCellName $up_row $col )" "$( NumberToCellName $row $left_col )

	elif [[ $col == $(( $total_col - 1 )) ]]; then
		associate_cell=$( NumberToCellName $up_row $col )" "$( NumberToCellName $down_row $col )" "$( NumberToCellName $row $left_col )

	elif [[ $row == $(( $total_row - 1 )) ]]; then
		associate_cell=$( NumberToCellName $up_row $col )" "$( NumberToCellName $row $right_col )" "$( NumberToCellName $row $left_col )

	elif (( $col == 0 )); then
		associate_cell=$( NumberToCellName $up_row $col )" "$( NumberToCellName $down_row $col )" "$( NumberToCellName $row $right_col )

	elif (( $row == 0 )); then
		associate_cell=$( NumberToCellName $down_row $col )" "$( NumberToCellName $row $left_col )" "$( NumberToCellName $row $right_col )

	else
		associate_cell=$( NumberToCellName $up_row $col )" "$( NumberToCellName $down_row $col )" "$( NumberToCellName $row $left_col )" "$( NumberToCellName $row $right_col  )

	fi

	echo $associate_cell
}


# Make file contains cells name, max value of each cell and associate cells
function InitiateCellInfoFile(){
	local col_pointer=0
	local row_pointer=0
	local cell_value=0
	touch cell_info.txt
	while (( $row_pointer < $total_row ))
	do
		while (( $col_pointer < $total_col ))
		do
			local cell_name=$( NumberToCellName $row_pointer $col_pointer )
			local cell_value=$( CellMaxValue $row_pointer $col_pointer )
			local associate_cell=$( AssociateCell $row_pointer $col_pointer )
			echo "$cell_name|$cell_value|$associate_cell" >> cell_info.txt
			col_pointer=$(( $col_pointer + 1 ))
		done
		col_pointer=0
		row_pointer=$(( $row_pointer + 1 ))
	done
}

# Make file contains cells name, and status
function InitiateStatusFile(){
	local col_pointer=0
	local row_pointer=0
	local cell_value=0
	touch status.txt
	while (( $row_pointer < $total_row ))
	do
		while (( $col_pointer < $total_col ))
		do
			local cell_name=$( NumberToCellName $row_pointer $col_pointer )
			echo "$cell_name|0|NONE" >> status.txt
			col_pointer=$(( $col_pointer + 1 ))
		done
		col_pointer=0
		row_pointer=$(( $row_pointer + 1 ))
	done
}


# INITIALIZE THE STRUCTURE INTO STRUCTURE.TXT FILE
#function InitStructure(){
#	echo -e "$structure" > structure.txt
#}
