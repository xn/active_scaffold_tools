function NukeBadChars(textElement)
{
 var strTemp = textElement.value;
 
	for (i=0; i < strTemp.length; i++)  
	{
	 if (
	  (strTemp.charAt(i) == "'") || 
	  (strTemp.charAt(i) == '"'))
		{
			strTemp = strTemp.substr(0,i) + strTemp.substr(i + 1);
			i--;
		}
 }
 textElement.value = strTemp
}

function NumberCleanUp(num)
{
	var sVal='';
	var nVal = num.length;
	var sChar='';
	// First 
 	try
	{
		for(i = 0 ; i < nVal; i++)
		{
			sChar = num.charAt(i);
			nChar = sChar.charCodeAt(0);
			if (sChar =='.')  
			{
//alert('here');
					sVal += num.charAt(i);   
//					i = nVal; // Done
			}
			else if ((nChar >=48) && (nChar <=57))  
			{ 
				sVal += num.charAt(i);   
			}
		}
	}
	catch (exception) { AlertError("Format Clean",e); }
	return sVal;
}

function PhoneDashAdd(textElement)
{
	var strTemp = textElement.value; 
	strTemp = NumberCleanUp(textElement.value);
	if (strTemp)
	{
		textElement.value = strTemp.substr(0,3) + '-' + strTemp.substr(3,3) + '-' + strTemp.substr(6); 
	}
}
