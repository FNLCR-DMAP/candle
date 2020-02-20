

outfile="val_to_return.json"
if [ -z "$candle_val_to_return" ]
then
    echo "ERROR: The return value $candle_val_to_return is empty" 1>&2 
else
    cat > $outfile << EOM
    {
        'val_loss':[ $candle_val_to_return ],
        'val_corr':[ $candle_val_to_return ],
        'val_dice_coef':[ $candle_val_to_return ]
    }
EOM

fi
