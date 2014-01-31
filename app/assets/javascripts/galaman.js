function moveOn(field) {
    if (field.value.length >= field.maxLength) { 
        $(field).next().focus();
    }
}
