# The object returned above must be called "temp" and of type data.frame with val_loss as a key, e.g., temp$val_loss

# append two copies of the temp value to the data.frame
# with a different name
temp$val_corr <- temp$val_loss
temp$val_dice_coef <- temp$val_loss

# convert the temp to a list
temp <- as.list(temp)

# write temp as a JSON object
# and save it as temp1
temp1 <- toJSON(temp)

# write temp1 (JSON object) to a file
write(temp1, file = "val_to_return.json")
