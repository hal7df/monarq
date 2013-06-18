.pragma library

function findIcon (height, icon, category)
{
    category = typeof category === 'undefined' ? "navigation" : category

    if (height < 48)
        return "images/mdpi/ic_"+category+"_"+icon+".png";
    else if (height >= 48 && height < 64)
        return "images/hdpi/ic_"+category+"_"+icon+".png";
    else
        return "images/xhdpi/ic_"+category+"_"+icon+".png";
}
