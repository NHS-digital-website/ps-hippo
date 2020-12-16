/*global console*/

/* ========================================================================================================

e-Learning For Healthcare AICC Wrapper for JavaScript (https://github.com/e-LfH/adapt-elfh-spoor)
v0.1

Created by Ian Robinson for e-Learning For Healthcare (http://www.e-lfh.org.uk), January 2017
Inspired by API.js pipwerks SCORM Wrapper for JavaScript (v1.1.20160322), used in the Adapt framework, 
which was created by Philip Hutchison, January 2008-2016 - https://github.com/pipwerks/scorm-api-wrapper

Currently has a dependence on the pipwerks.UTILS object for reporting status and error messages

======================================================================================================== */

var elfh = {};                                      //elfh 'namespace' helps ensure no conflicts with possible other "SCORM" variables

elfh.AICC = {                                       //Define the SCORM object
    version:    "aicc",                             //Store SCORM version.
    handleCompletionStatus: true,                   //Whether or not the wrapper should automatically handle the initial completion status
    handleExitMode: true,                           //Whether or not the wrapper should automatically handle the exit mode
    API:        { handle: null,                     // handle contains a reference to the AICC_LMS object
                  isFound: false },                 // was an AICC_LMS object found?
    isConnected: false,
    data:       { completionStatus: null,
                  exitStatus: null },               //Create data child object
    debug:      {}                                  //Create debug child object
};

/* -------------------------------------------------------------------------
   Looks in the query string for the text aicc_sid and aicc_url.
   If these variables exist, then the course has been called by via an AICC
   LMS, so return the AICC LMS object API.

   Parameters:  None.
   Returns:     AICC LMS API if aicc id and url are found, otherwise null is
                returned.
---------------------------------------------------------------------------- */

elfh.AICC.API.get = function(){

    var API = null,
        win = window,
        aicc = elfh.AICC,
        traceMsgPrefix = "AICC.API.get",
        trace = pipwerks.UTILS.trace;

    // see if an AICC connection request has been sent
    try {

        var s = win.location.search;

        var aiccId = "";
        var aiccUrl = "";

        // look in the query string for the text aicc_sid and aicc_url
        if (s.length > 0) {
            var arPairs = s.split("&");
            for (var i = 0; i < arPairs.length; i++) {
                if (arPairs[i].indexOf("?") == 0)
                    arPairs[i] = arPairs[i].substring(1, arPairs[i].length);

                var arPair = arPairs[i].split("=");
                if (arPair.length == 2) {
                    var sName = arPair[0];
                    var sValue = arPair[1];

                    sName = sName.toLowerCase();
                    switch (sName) {
                        case "aicc_sid":
                            aiccId = unescape(sValue);
                            break;
                        case "aicc_url":
                            aiccUrl = unescape(sValue);
                            break;
                    }
                }
            }

            // if both an AICC id and url have been found then
            // this request must have come from an AICC LMS
            if (aiccId != "" && aiccUrl != "") {

                //self.LMS = new AICC_LMS();
                API = new AICC_LMS();
                API.Id = aiccId;
                API.LmsUrl = aiccUrl;

            }

        }

    }
    catch (e) {

        trace(traceMsgPrefix +": AICC initialise connection failed. " + e.toString());
        throw e;
    }


    if(API){
        aicc.API.isFound = true;
    } else {
        trace("API.get failed: Can't find the AICC API!");
    }

    return API;

};


/* -------------------------------------------------------------------------
   Returns the handle to API object if it was previously set

   Parameters:  None.
   Returns:     Object.
---------------------------------------------------------------------------- */

elfh.AICC.API.getHandle = function() {

    var API = elfh.AICC.API;

    // if no API exists, try to find one
    if(!API.isFound){

        API.handle = API.get();

    }

    return API.handle; // handle contains a reference to the AICC_LMS object

};

/* -------------------------------------------------------------------------

   Tells the LMS to initiate the communication session.

   Parameters:  None
   Returns:     Boolean
---------------------------------------------------------------------------- */
elfh.AICC.init = function(){
 
    var success = false,
        aicc = elfh.AICC,
        completionStatus = aicc.data.completionStatus, // ??
        trace = pipwerks.UTILS.trace,
        makeBoolean = pipwerks.UTILS.StringToBoolean,
        debug = aicc.debug,
        traceMsgPrefix = "AICC.connection.initialize ";

    trace("AICC initialize called.");

    if(!aicc.isConnected){

        var API = aicc.API.getHandle(),
            errorCode = 0;

        if(API){
            
            switch(aicc.version){
                
                case "1.2":
                case "aicc": 
                    success = makeBoolean(API.LMSInitialize("")); 
                    break;

                case "2004": 
                    success = makeBoolean(API.Initialize("")); 
                    break;
            }

            if(success){

                //Double-check that connection is active and working before returning 'true' boolean
                errorCode = debug.getCode(); // ?

                if(errorCode !== null && errorCode === 0){

                    aicc.isConnected = true;

                    if(aicc.handleCompletionStatus){ // set to true by default

                        //Automatically set new launches to incomplete
                        completionStatus = aicc.status("get");

                        if (completionStatus) {

                            switch(completionStatus){

                                // if the lession status is not attempted, i.e. the first time the session
                                // has been accessed, then set the status to incomplete
                                case "not attempted": // SCORM 1.2
                                case "not attempted, ab-initio": // AICC
                                    aicc.status("set", "incomplete"); 
                                    break;

                                //Additional options, presented here in case you'd like to use them
                                //case "completed"  : break;
                                //case "incomplete" : break;
                                //case "passed"     : break;    //SCORM 1.2 only
                                //case "failed"     : break;    //SCORM 1.2 only
                                //case "browsed"    : break;    //SCORM 1.2 only
                                default: 
                                    trace(traceMsgPrefix + " unrecognised status value of " + completionStatus);
                                    break;
                            }

                            //Commit changes
                            aicc.save();

                        }

                    }

                } else {

                    success = false;
                    trace(traceMsgPrefix +"failed. \nError code: " +errorCode +" \nError info: " +debug.getInfo(errorCode));

                }

            } else {

                errorCode = debug.getCode();

                if(errorCode !== null && errorCode !== 0){

                    trace(traceMsgPrefix +"failed. \nError code: " +errorCode +" \nError info: " +debug.getInfo(errorCode));

                } else {

                    trace(traceMsgPrefix +"failed: No response from server.");

                }
            }

        } else {

            trace(traceMsgPrefix +"failed: API is null.");

        }

    } else {

          trace(traceMsgPrefix +"aborted: Connection already active.");

     }

     return success;

};


/* -------------------------------------------------------------------------
   Tells the LMS to terminate the communication session

   Parameters:  None
   Returns:     Boolean
---------------------------------------------------------------------------- */
elfh.AICC.quit = function() {

    var success = false,
        aicc = elfh.AICC,
        exitStatus = aicc.data.exitStatus,
        completionStatus = aicc.data.completionStatus,
        trace = pipwerks.UTILS.trace,
        makeBoolean = pipwerks.UTILS.StringToBoolean,
        debug = aicc.debug,
        traceMsgPrefix = "elfh.AICC.quit ";


    if(aicc.isConnected){

        var API = aicc.API.getHandle()
        var errorCode = 0;

        if(API){

             if(aicc.handleExitMode && !exitStatus){

                if(completionStatus !== "completed" && completionStatus !== "passed"){

                    
                    switch(aicc.version){
                        case "1.2":
                        case "aicc":
                            success = aicc.set("cmi.core.exit", "suspend"); 
                            break;
                        case "2004": 
                            success = aicc.set("cmi.exit", "suspend"); 
                            break;
                    }

                } else {

                    switch(aicc.version){
                        case "1.2":
                        case "aicc": 
                            success = aicc.set("cmi.core.exit", "logout"); 
                            break;
                        case "2004": 
                            success = aicc.set("cmi.exit", "normal"); 
                            break;
                    }

                }

            }

            if(success){

                switch(aicc.version){
                    case "1.2":
                    case "aicc": 
                        success = makeBoolean(API.LMSFinish("")); 
                        break;
                    case "2004": 
                        success = makeBoolean(API.Terminate("")); 
                        break;
                }

                if(success){

                    aicc.isConnected = false;

                } else {

                    errorCode = debug.getCode();
                    trace(traceMsgPrefix +"failed. \nError code: " +errorCode +" \nError info: " +debug.getInfo(errorCode));

                }

            }

        } else {

            trace(traceMsgPrefix +"failed: API is null.");

        }

    } else {

        trace(traceMsgPrefix +"aborted: Connection already terminated.");

    }

    return success;

};


/* -------------------------------------------------------------------------

   Requests information from the LMS.

   Parameter: parameter (string, name of the SCORM data model element)
   Returns:   string (the value of the specified data model element)
---------------------------------------------------------------------------- */
elfh.AICC.get = function(parameter) {

    var value = null,
        aicc = elfh.AICC,
        trace = pipwerks.UTILS.trace,
        debug = aicc.debug,
        traceMsgPrefix = "AICC.get('" +parameter +"') ";

    if(aicc.isConnected){

        var API = aicc.API.getHandle(),
            errorCode = 0;

          if(API){

            switch(aicc.version){
                case "1.2":
                case "aicc":
                    value = API.LMSGetValue(parameter); 
                    break;
                case "2004": 
                    value = API.GetValue(parameter); 
                    break;
            }

            errorCode = debug.getCode();

            //GetValue returns an empty string on errors
            //If value is an empty string, check errorCode to make sure there are no errors
            if(value !== "" || errorCode === 0){

                //GetValue is successful.
                //If parameter is lesson_status/completion_status or exit status, let's
                //grab the value and cache it so we can check it during connection.terminate()
                
                switch(parameter){

                    case "cmi.core.lesson_status":
                    case "cmi.completion_status" : aicc.data.completionStatus = value; break;

                    case "cmi.core.exit":
                    case "cmi.exit"     : aicc.data.exitStatus = value; break;

                }
                

            } else {

                trace(traceMsgPrefix +"failed. \nError code: " +errorCode +"\nError info: " +debug.getInfo(errorCode));

            }

        } else {

            trace(traceMsgPrefix +"failed: API is null.");

        }

    } else {

        trace(traceMsgPrefix +"failed: API is not connected to the LMS.");

    }

    trace(traceMsgPrefix +" value: " +value);

    return String(value);

};


/* -------------------------------------------------------------------------
   Tells the LMS to assign the value to the named data model element.
   Also stores the SCO's completion status in a variable. This variable is checked whenever
   the elfh.AICC.quit method is invoked.

   Parameters: parameter (string). The data model element
               value (string). The value for the data model element
   Returns:    Boolean
---------------------------------------------------------------------------- */
elfh.AICC.set = function(parameter, value){

    var success = false,
        aicc = elfh.AICC,
        trace = pipwerks.UTILS.trace,
        makeBoolean = pipwerks.UTILS.StringToBoolean,
        debug = aicc.debug,
        traceMsgPrefix = "AICC.set('" +parameter +"') ";


    if(aicc.isConnected){

        var API = aicc.API.getHandle(),
            errorCode = 0;

        if(API){

            switch(aicc.version){
                case "1.2":
                case "aicc":
                    success = makeBoolean(API.LMSSetValue(parameter, value)); 
                    break;
                case "2004": 
                    success = makeBoolean(API.SetValue(parameter, value)); 
                    break;
            }

            if(success){

                if(parameter === "cmi.core.lesson_status" || parameter === "cmi.completion_status"){

                    aicc.data.completionStatus = value;

                }

            } else {

                errorCode = debug.getCode();

                trace(traceMsgPrefix +"failed. \nError code: " +errorCode +". \nError info: " +debug.getInfo(errorCode));

            }

        } else {

            trace(traceMsgPrefix +"failed: API is null.");

        }

    } else {

        trace(traceMsgPrefix +"failed: API connection is inactive.");

    }

	trace(traceMsgPrefix +" value: " +value);

    return success;

};


/* -------------------------------------------------------------------------
   Instructs the LMS to save all data from this session, i.e. perform a commit

   Parameters: None
   Returns:    Boolean
---------------------------------------------------------------------------- */
elfh.AICC.save = function() {

    var success = false,
        aicc = elfh.AICC,
        trace = pipwerks.UTILS.trace,
        makeBoolean = pipwerks.UTILS.StringToBoolean,
        traceMsgPrefix = "AICC.save failed";


    if(aicc.isConnected){

        var API = aicc.API.getHandle();

        if(API){

            switch(aicc.version){
                case "1.2":
                case "aicc": 
                    success = makeBoolean(API.LMSCommit("")); 
                    break;
                case "2004": 
                    success = makeBoolean(API.Commit("")); 
                    break;
            }

        } else {

            trace(traceMsgPrefix +": API is null.");

        }

    } else {

        trace(traceMsgPrefix +": API connection is inactive.");

    }

    return success;

};


elfh.AICC.status = function (action, status){

    var success = false,
        aicc = elfh.AICC,
        trace = pipwerks.UTILS.trace,
        traceMsgPrefix = "AICC.getStatus failed",
        cmi = "";

    if(action !== null){

        switch(aicc.version) {

            case "1.2":
            case "aicc": 
                cmi = "cmi.core.lesson_status"; 
                break;
            case "2004": 
                cmi = "cmi.completion_status"; 
                break;

        }

        switch(action){

            case "get": 
                success = aicc.get(cmi); break;
                break;

            case "set": 
                if(status !== null){

                    success = aicc.set(cmi, status);

                } else {

                    success = false;
                    trace(traceMsgPrefix +": status was not specified.");

                }

                break;

            default: success = false;
                        trace(traceMsgPrefix +": no valid action was specified.");

        }

    } else {

        trace(traceMsgPrefix +": action was not specified.");

    }

    return success;

};


/* -------------------------------------------------------------------------
   Requests the error code for the current error state from the LMS

   Parameters: None
   Returns:    Integer (the last error code).
---------------------------------------------------------------------------- */
elfh.AICC.debug.getCode = function(){

    var aicc = elfh.AICC,
        API = aicc.API.getHandle(),
        trace = pipwerks.UTILS.trace,
        code = 0;

    if(API){

        switch(aicc.version){
            case "1.2":
            case "aicc":
                code = parseInt(API.LMSGetLastError(), 10); 
                break;
            case "2004": 
                code = parseInt(API.GetLastError(), 10); 
                break;
        }

    } else {

        trace("AICC.debug.getCode failed: API is null.");

    }

    return code;

};


/* -------------------------------------------------------------------------
   "Used by a SCO to request the textual description for the error code
   specified by the value of [errorCode]."

   Parameters: errorCode (integer).
   Returns:    String.
----------------------------------------------------------------------------- */
elfh.AICC.debug.getInfo = function(errorCode){

    var aicc = elfh.AICC,
        API = aicc.API.getHandle(),
        trace = pipwerks.UTILS.trace,
        result = "";


    if(API){

        switch(aicc.version){
            case "1.2":
            case "aicc":
                result = API.LMSGetErrorString(errorCode.toString()); 
                break;
            case "2004": 
                result = API.GetErrorString(errorCode.toString()); 
                break;
        }

    } else {

        trace("AICC.debug.getInfo failed: API is null.");

    }

    return String(result);

};

/* -------------------------------------------------------------------------
   "Exists for LMS specific use. It allows the LMS to define additional
   diagnostic information through the API Instance."

   Parameters: errorCode (integer).
   Returns:    String (Additional diagnostic information about the given error code).
---------------------------------------------------------------------------- */
elfh.AICC.debug.getDiagnosticInfo = function(errorCode){

    
    var aicc =  elfh.AICC,
        API = scorm.API.getHandle(),
        trace = pipwerks.UTILS.trace,
        result = "";

    if(API){

        switch(scorm.version){
            case "aicc": result = ""; break;
            case "1.2": result = API.LMSGetDiagnostic(errorCode); break;
            case "2004": result = API.GetDiagnostic(errorCode); break;
        }

    } else {

        trace("AICC.debug.getDiagnosticInfo failed: API is null.");

    }

    return String(result);

};
