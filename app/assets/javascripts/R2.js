/* start /web-platform/scripts/web-platform/reg/registration2.js*/
window.SOE = window.SOE || {};
SOE.Registration = (function() {
    if (wpCookie("wr-underage") == "true") {
        return;
    }
    var submitUrl = globs.urls.uramAjaxUrl + "/reg/v1/register.action";
    var returnUrl = globs.urlparameters.returnURL || $("input[name=service]").val();
    var underage = 13;
    var OPTIN_OFF_LIST;
    var _VALIDATION_MAP = {
        "wrCreateUsername": ["isUsernameSize", "isUsernameValid"],
        "password1": ["isPasswordSize", "isPasswordValid", "passwordHasNumberAndLetter", "isPasswordNotStationName"],
        "password2": ["isPasswordSize", "isPasswordValid", "passwordHasNumberAndLetter", "isPasswordNotStationName", "isPasswordMatches"],
        "emailAddress": ["isEmailValid"]
    };
    var $_FORM = $("form#registration");
    var $_AUTO_LOGIN = $("form#autoLogIn");
    var $_AGE_ERROR = $_FORM.find(".dob-error");
    var $_CHECKBOX_ERROR = $_FORM.find(".tos-error");
    var $_GLOBAL_ERROR = $(".global-error");
    var CountrySelection = (function() {
        var gettingCountries = new $.Deferred();
        var userProfile = {
            country: {
                code: "US",
                from: "United States",
                partner: ""
            },
            referrer: {
                steamCustomer: false
            },
            gotCountryList: function() {
                return gettingCountries.promise();
            }
        };
        var getCountries = function() {
            $.ajax({
                url: globs.urls.uramAjaxUrl + "/reg/v1/getCountries2.action",
                dataType: "json",
                type: "post",
                data: {
                    locale: globs.soelocale,
                    theme: globs.wdl.theme,
                    responseType: "json"
                },
                success: setCountryList,
                error: function(response) {
                    gettingCountries.reject(response);
                }
            });
            if ((globs.urlparameters && globs.urlparameters.launchPoint == "steam") || wpCookie('launchedBySteam')) {
                userProfile.referrer.steamCustomer = true;
                wpCookie("steamCustomer", true, 30);
                wpCookie('launchedBySteam', true);
            }
        };
        var setCountryList = function(data) {
            gettingCountries.resolve(data);
            OPTIN_OFF_LIST = data.optinDefaultOff || [];
            if (typeof data.sourceCountry !== "undefined" && data.sourceCountry) {
                if ($.inArray(data.sourceCountry.countrycode, OPTIN_OFF_LIST) != -1) {
                    $_FORM[0].acceptMktg.checked = false;
                }
                userProfile.country.code = data.sourceCountry.countrycode;
                userProfile.country.description = data.sourceCountry.description;
            } else {
                $_FORM[0].acceptMktg.checked = false;
            }
            if (userProfile.referrer.steamCustomer === false) {
                if (data.partner !== "") {
                    userProfile.country.partner = data.partner;
                    showGate(data);
                }
            }
            renderCountries(data);
        };
        var showGate = function() {
            var _partner = userProfile.country.partner.toLowerCase();
            if (typeof _partner !== 'undefined') {
                $("#ipGate").on("loaded.bs.modal", function() {
                    $('#location h2#country').html(userProfile.country.description);
                });
                $("#ipGate").modal({
                    remote: "_pageContent/modals/gate-" + _partner + ".vm",
                    backdrop: "static"
                });
            }
        };
        var renderCountries = function(data) {
            var _countryList = document.getElementById("countryList");
            var _selectList = document.createElement("select");
            var _wrapper = document.createElement("div");
            _wrapper.className = "fancy-select country";
            _selectList.className = "form-control";
            _selectList.id = "wrCreateCountry";
            _selectList.name = "country";
            _selectList.tabIndex = "5";
            data.countries.forEach(function(country) {
                var _option = document.createElement("option");
                _option.value = country.countrycode;
                _option.innerHTML = country.description;
                if (typeof data.sourceCountry !== "undefined" && typeof data.sourceCountry.countrycode !== "undefined" && data.sourceCountry.countrycode == country.countrycode) {
                    _option.selected = "selected";
                }
                _selectList.appendChild(_option);
            });
            _wrapper.appendChild(_selectList);
            _countryList.innerHTML = "";
            _countryList.appendChild(_wrapper);
            TermsOfService.getTOS();
        };
        getCountries();
        return userProfile;
    })();
    var PasswordStregthMeter = (function() {
        var $_PASSWORD_METER = $("#passwordStrength");
        var $_PASSWORD_METER_TOOLTIP = $(".password-strength-tooltip");
        var _MAX_REPEAT = 2;
        var _MAX_SEQUENCE = 4;
        var _BAD_PASSWORDS = ["password", "password1", "password12", "passw0rd", "12345678", "123456789", "1234567890", "trustno1", "baseball", "b@seball", "b@seb@all", "football", "f00tball", "iloveyou", "sunshine", "superman", "welcome", "consumer", "sunshine", "princess", "starwars", "starwars(!)", "whatever", "12312312", "123123123", "Nintendo", "computer", "blahblah", "Jennifer", "internet", "trustno1", "69696969", "welcome", "12121212", "zaq1zaq1", "1qaz2wsx", "dragon", "master", "letmein", "qwerty", "qwertyui", "qwertyuio", "qwertyuiop", "hottie"];
        var _ALPHA = 'abcdefghijklmnopqrstuvwxyz';
        var _REVERSE_ALPHA = _ALPHA.split("").reverse().join("");
        var _NUMBERS = '1234567890';
        var _REVERSE_NUMBERS = _NUMBERS.split("").reverse().join("");
        var _METER_RATINGS = ["Too short", "Weak", "Good", "Strong", ];
        var _TOOL_TIP_TEXT = ['Try a mix of capital letters, numbers, and acceptable special characters (!&quot;#$&%)', 'Your password is weak. Try not repeating or using sequential characters.', 'Your password could be stronger. Try a mix of capital letters, numbers, and acceptable special characters (!&quot;#$&%)', '<i class="fa fa-check-circle"></i>&nbsp;Congratulations, your password is strong!'];
        var _hasRepeatSequenceOrBadPassword = function(password) {
            if (_BAD_PASSWORDS.indexOf(password)) {
                return true;
            }
            var index = 0;
            var numericSequence = [];
            var alphabeticicSequence = [];
            while (index + 1 < password.length && Validator.isNumeric(password[index]) && Validator.isNumeric(password[index + 1])) {
                numericSequence.push(password[index]);
                numericSequence.push(password[index + 1]);
                index = index + 2;
            }
            while (index + 1 < password.length && Validator.isAlphabetic(password[index]) && Validator.isAlphabetic(password[index + 1])) {
                alphabeticicSequence.push(password[index]);
                alphabeticicSequence.push(password[index + 1]);
                index = index + 2;
            }
            return (numericSequence.length > 2 || alphabeticicSequence.length > 2);
        };
        var _checkRepeats = function(password) {
            var j, k;
            for (k = 0; k < password.length; k++) {
                for (j = 1; j < (_MAX_REPEAT + 1); j++) {
                    if ((j + k) > password.length) {
                        break;
                    }
                    if (password[k] !== password[k + j]) {
                        break;
                    }
                    if (j == _MAX_REPEAT) {
                        return true;
                    }
                }
            }
            return false;
        };
        var _checkSequence = function(password) {
            var k;
            for (k = 0; k < (_NUMBERS.length - _MAX_SEQUENCE); k++) {
                if ((password.indexOf(_NUMBERS.substring(k, k + _MAX_SEQUENCE)) != -1) || (password.indexOf(_REVERSE_NUMBERS.substring(k, k + _MAX_SEQUENCE)) != -1)) {
                    return true;
                }
            }
            for (k = 0; k < (_ALPHA.length - _MAX_SEQUENCE); k++) {
                if ((password.indexOf(_ALPHA.substring(k, k + _MAX_SEQUENCE)) != -1) || (password.indexOf(_REVERSE_ALPHA.substring(k, k + _MAX_SEQUENCE)) != -1)) {
                    return true;
                }
            }
            return false;
        };
        var getStrength = function() {
            var _strength = 0;
            var _password = $_FORM[0].password1.value;
            if (_password.length >= 8) {
                if (!_checkSequence(_password) && !_checkRepeats(_password)) {
                    if ((/[A-Z]/.test(_password) && /[a-z]/.test(_password)) && /[\$\!\"\%\#]/.test(_password) && _password.length > 9) {
                        _strength = 3;
                    } else {
                        _strength = 2;
                    }
                } else {
                    _strength = 1;
                }
            } else {
                _strength = 0;
            }
            return _strength;
        };
        var updateMeter = function() {
            var strength = getStrength();
            $_PASSWORD_METER_TOOLTIP.attr("data-original-title", _TOOL_TIP_TEXT[strength]);
            $_PASSWORD_METER.find("#progress")[0].className = "strength-" + strength;
            $_PASSWORD_METER.find(".strength-text").html(_METER_RATINGS[strength]);
        };
        var _passwordStrengthTooltip = function() {
            $_PASSWORD_METER_TOOLTIP.tooltip({
                html: true
            });
        };
        _passwordStrengthTooltip();
        return {
            getStrength: getStrength,
            updateMeter: updateMeter
        };
    })();
    var Validator = (function() {
        var _ALPHA_SYMBOL_REGEX = /^[A-Za-z0-9\$\!\"\%\#]+$/;
        var _ALPHA_NUMERAL_REGEX = /^(?=.*[0-9])(?=.*[a-zA-Z])(.+)$/;
        var _ALPHA_REGEX = /^[A-Za-z0-9]+$/;
        var _USERNAME_REGEX = /^[a-zA-Z0-9]{4,15}$/;
        var _PASSWORD_REGEX = /^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9!\"#\\$\\%]{8,15})$/;
        var _EMAIL_REGEX = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var _stationNameValid = true;
        var _stationNameSuggestions = [];
        var _stationNamePlaceholder = "";
        var _checkSize = function(text, min, max) {
            return (text.length >= min && text.length <= max);
        };
        var isNumeric = function(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        };
        var isAlphabetic = function(n) {
            return /^[a-zA-Z]+$/.test(n);
        };
        var isUsernameSize = function() {
            alert(getElementById("wrCreateUsername").value);
            return _checkSize($_FORM[0].getElementById("wrCreateUsername").value, 4, 15);
        };
        var isUsernameValid = function() {
            return _ALPHA_REGEX.test($_FORM[0].getElementById("wrCreateUsername").value);
        };
        var isUsernameTaken = function() {
            if (!isUsernameValid() || !isUsernameSize()) {
                $_FORM.getElementById("wrCreateUsername").parents(".form-group").addClass("has-error");
                return false;
            }
            if (_stationNamePlaceholder === $_FORM[0].getElementById("wrCreateUsername").value) {
                usernameStateChange(_stationNameValid, _stationNameSuggestions);
                return _stationNameValid;
            }
            $.ajax({
                url: globs.urls.uramAjaxUrl + "/validation/fieldValidation!stationName.action",
                dataType: "json",
                data: {
                    value: encodeURIComponent($_FORM[0].getElementById("wrCreateUsername").value)
                },
                type: "post",
                success: _usernameTakenSuccess
            });
            _stationNamePlaceholder = $_FORM[0].getElementById("wrCreateUsername").value;
            $_FORM.find("[data-error=isUsernameTaken] .suggestions").text("");
        };
        var _formatSuggestions = function(suggestions) {
            var suggestionText = "(how about {namesList}?)".replace("{namesList}", suggestions.join(", "));
            var lastComma = suggestionText.lastIndexOf(", ");
            if (globs.soelocale.indexOf("en_") === 0 && lastComma >= 0) {
                suggestionText = suggestionText.slice(0, lastComma) + ", or " + suggestionText.slice(lastComma + 2);
            }
            return suggestionText;
        };
        var usernameStateChange = function(valid, suggestions) {
            if (valid) {
                $_FORM.getElementById("wrCreateUsername").parents(".form-group").removeClass("has-error");
                $_FORM.find("[data-error=isUsernameTaken]").removeClass("has-error").addClass("has-success").find(".suggestions").text("");
            } else {
                $_FORM.getElementById("wrCreateUsername").parents(".form-group").addClass("has-error");
                $_FORM.find("[data-error=isUsernameTaken]").removeClass("has-success").addClass("has-error").find(".suggestions").html(_formatSuggestions(suggestions));
            }
        };
        var _usernameTakenSuccess = function(data) {
            _stationNameValid = data.valid;
            _stationNameSuggestions = data.suggestedStationNames;
            usernameStateChange(_stationNameValid, _stationNameSuggestions);
        };
        var isPasswordSize = function() {
            return _checkSize($_FORM[0].password1.value, 8, 15);
        };
        var isPasswordValid = function() {
            return _ALPHA_SYMBOL_REGEX.test($_FORM[0].password1.value);
        };
        var passwordHasNumberAndLetter = function() {
            return _ALPHA_NUMERAL_REGEX.test($_FORM[0].password1.value);
        };
        var isPasswordNotStationName = function() {
            return ($_FORM[0].getElementById("wrCreateUsername").value !== $_FORM[0].password1.value);
        };
        var isPasswordMatches = function() {
            if ($_FORM[0].skipPasswordConfirm.checked) {
                return true;
            }
            return ($_FORM[0].password1.value === $_FORM[0].password2.value);
        };
        var _getValidAge = function() {
            var _year = parseInt($_FORM[0].dobYear.value, 10);
            var _month = parseInt($_FORM[0].dobMonth.value, 10);
            var _day = parseInt($_FORM[0].dobDay.value, 10);
            var _birthday = new Date(_year, _month - 1, _day);
            if (isNaN(_birthday.getTime())) {
                return false;
            } else {
                return _birthday;
            }
        };
        var isOverAge = function() {
            var _birthday = _getValidAge();
            if (!_birthday) {
                return false;
            }
            var _cutOff = new Date();
            _cutOff.setFullYear(_cutOff.getFullYear() - underage);
            return (_cutOff.getTime() - _birthday.getTime());
        };
        var isEmailValid = function() {
            return _EMAIL_REGEX.test($_FORM[0].emailAddress.value);
        };
        var validatorPasses = function(validationType) {
            return Validator[validationType]();
        };
        var validateForm = function() {
            var COOKIE_EXPIRE_MINUTES = 2;
            var domain = window.location.hostname;
            var cookieExpire = new Date(Date.now() + (COOKIE_EXPIRE_MINUTES * 60 * 1000));
            var needsPP = !$('#privacyPolicy').hasClass('hidden');
            var _passed = true;
            _.keys(_VALIDATION_MAP).forEach(function(field) {
                var isValid = _VALIDATION_MAP[field].every(validatorPasses);
                $_FORM.find("[name=" + field + "]").parents(".form-group").toggleClass("has-error", !isValid);
                _passed = _passed && isValid;
            });
            if (_passed) {
                wpCookie("reg-email", $("input[name='emailAddress']").val(), cookieExpire, domain, true);
                wpCookie("reg-password", $("input[name='password2']").val(), cookieExpire, domain, true);
            } else {
                wpCookie("reg-email", "", -1, domain, true);
                wpCookie("reg-password", "", -1, domain, true);
            }
            if (!isOverAge()) {
                $_AGE_ERROR.removeClass("hidden");
                _passed = false;
            } else if (isOverAge() < 0) {
                $_AGE_ERROR.addClass("hidden");
                _underageLockout();
                _passed = false;
            } else {
                $_AGE_ERROR.addClass("hidden");
            }
            if (!$_FORM[0].tosAccepted.checked || (needsPP && !$_FORM[0].privacyPolicyAccepted.checked)) {
                $_CHECKBOX_ERROR.removeClass("hidden");
                _passed = false;
            } else {
                $_CHECKBOX_ERROR.addClass("hidden");
            }
            return _passed;
        };
        var _underageLockout = function() {
            wpCookie('wr-underage', true, new Date((new Date()).getTime() + (24 * 60 * 60 * 1000)));
            $('.web-registration .panes .pane.reg-form').html("<div id='wrSubscriptionUnderage' class='underAge'>We're sorry, but you are unable to sign up for a Daybreak Account at this time.</div>");
            $(document).trigger('regUnderageLockout');
        };
        return {
            isNumeric: isNumeric,
            isOverAge: isOverAge,
            isAlphabetic: isAlphabetic,
            isEmailValid: isEmailValid,
            validateForm: validateForm,
            isPasswordSize: isPasswordSize,
            isUsernameSize: isUsernameSize,
            isUsernameValid: isUsernameValid,
            isUsernameTaken: isUsernameTaken,
            isPasswordValid: isPasswordValid,
            isPasswordMatches: isPasswordMatches,
            isPasswordNotStationName: isPasswordNotStationName,
            passwordHasNumberAndLetter: passwordHasNumberAndLetter
        };
    })();
    var FormEvents = (function() {
        var init = function() {
            toggleRequirements();
            showPassword();
            validateInputs();
            regStartTracking();
        };
        var regStartTracking = function() {
            $_FORM.one("focus", "input", function() {
                try {
                    DTKR.sendEvent("webRegStart");
                } catch (e) {}
            });
        };
        var toggleRequirements = function() {
            $_FORM.on("focus", "input:not([type=checkbox])", function() {
                var $_this = $(this);
                $_this.parents(".form-group").find(".requirements").addClass("expanded");
                $_this.parents(".highlight").addClass("selected-group");
            });
            $_FORM.on("blur", "input:not([type=checkbox]),select", function() {
                $_FORM.find(".requirements").removeClass("expanded").addClass("retracted");
                $_FORM.find(".highlight").removeClass("selected-group");
            });
        };
        var showPassword = function() {
            $_FORM.on("click", "[name=skipPasswordConfirm]", function() {
                var $_this = $(this);
                if ($_this.is(":checked")) {
                    $_FORM.find(".password-confirm").addClass("hidden");
                    $_FORM.find("[data-error=isPasswordMatches]").addClass("hidden");
                    $_FORM.find("[name=password1]").attr("type", "text");
                } else {
                    $_FORM.find(".password-confirm").removeClass("hidden");
                    $_FORM.find("[data-error=isPasswordMatches]").removeClass("hidden");
                    $_FORM.find("[name=password1]").attr("type", "password");
                }
            });
        };
        var validateInputs = function() {
            $_FORM.on("keyup change", "input", SOE.Utils.debounce(function() {
                var $_this = $(this);
                var _name = $_this[0].id;
                var _passed = true;
                $_this.parents(".form-group").removeClass("has-error");
                if (typeof _VALIDATION_MAP[_name] !== 'undefined' && $_this[0].value !== "") {
                    _VALIDATION_MAP[_name].forEach(function(validationType) {

                        var thisPassed = Validator[validationType]();
                        $_this.parents(".form-group").find("[data-error=" + validationType + "]").toggleClass("has-success", thisPassed).toggleClass("has-error", !thisPassed);
                        _passed = _passed && thisPassed;
                    });
                }
                if (!_passed) {
                    $_this.parents(".form-group").addClass("has-error");
                }
            }, 400));
            $_FORM.on("keyup blur", "[name=password1]", function() {
                PasswordStregthMeter.updateMeter();
            });
            $_FORM.on("keyup blur", "[name=password1], [name=password2]", function() {
                if ($(this).val().length > 0) {
                    $('#passwordStrength').show();
                }
            });
            $_FORM.one("focus", "[name=password2]", function() {
                _VALIDATION_MAP.password1.push("isPasswordMatches");
            });
            $_FORM.on("focus", "input", function() {
                $_GLOBAL_ERROR.addClass("hidden").html("");
            });
            $_FORM.on("blur", "input", function() {
                var $_this = $(this);
                var _name = $_this[0].name;
                var _passed = true;
                $_this.parents(".form-group").removeClass("has-error");
                if (_name == 'stationName') {
                    Validator.isUsernameTaken();
                }
                if (typeof _VALIDATION_MAP[_name] !== 'undefined') {
                    _VALIDATION_MAP[_name].forEach(function(validationType) {
                        var thisPassed = Validator[validationType]();
                        $_this.parents(".form-group").find("[data-error=" + validationType + "]").toggleClass("has-success", thisPassed).toggleClass("has-error", !thisPassed);
                        _passed = _passed && thisPassed;
                    });
                }
                if (!_passed) {
                    $_this.parents(".form-group").addClass("has-error");
                }
            });
        };
        return {
            init: init
        };
    })();
    var TermsOfService = (function() {
        var $_PRIVACY_POLICY = $("#privacyPolicy");
        var $_IT_TEXT = $("#itLegalText");
        var $_TOS_TEXT = $(".tos-text");
        var $_PP_TEXT = $(".pp-text");
        var getTOS = function() {
            $.ajax({
                url: globs.urls.uramAjaxUrl + "/reg/v1/getTosPpInfo.action",
                dataType: "json",
                type: "post",
                data: {
                    locale: globs.soeLocale,
                    theme: globs.wdl.theme,
                    country: $_FORM[0].country.value || "US",
                    responseType: "json"
                },
                success: setTOS
            });
        };
        var setTOS = function(data) {
            var boxes;
            for (boxes in data.checkboxes) {
                if (data.checkboxes[boxes].type == "TOS_PP") {
                    $_PRIVACY_POLICY.addClass("hidden");
                    $_IT_TEXT.hide();
                    $_TOS_TEXT.html(data.checkboxes[boxes].label);
                } else if (data.checkboxes[boxes].type == "TOS") {
                    if ($_FORM[0].country.value == "IT") {
                        $_TOS_TEXT.html(data.checkboxes[boxes].label.slice(0, data.checkboxes[boxes].label.indexOf("<br>")));
                        $_IT_TEXT.show().html("<p>" +
                            data.checkboxes[boxes].label.substr(data.checkboxes[boxes].label.indexOf("<br>")) + "</p>");
                    } else {
                        $_IT_TEXT.hide();
                        $_TOS_TEXT.html(data.checkboxes[boxes].label);
                    }
                } else if (data.checkboxes[boxes].type == "PP") {
                    $_PRIVACY_POLICY.removeClass("hidden");
                    $_PP_TEXT.html(data.checkboxes[boxes].label);
                }
            }
            clearCheckboxes();
        };
        var clearCheckboxes = function() {
            $_FORM[0].tosAccepted.checked = false;
            $_FORM[0].privacyPolicyAccepted.checked = false;
        };
        $_FORM.on("change", "[name=country]", function() {
            getTOS();
            if ($.inArray($(this).val(), OPTIN_OFF_LIST) != -1) {
                $_FORM[0].acceptMktg.checked = false;
            }
        });
        return {
            getTOS: getTOS
        };
    })();
    var FormProcessor = (function() {
        var submitForm = function() {
            if (Validator.validateForm()) {
                $_GLOBAL_ERROR.addClass("hidden").html("");
                var formData = {
                    stationName: $_FORM[0].getElementById("wrCreateUsername").value,
                    password1: $_FORM[0].password1.value,
                    emailAddress: $_FORM[0].emailAddress.value,
                    country: $_FORM[0].country.value,
                    dobDay: $_FORM[0].dobDay.value,
                    dobMonth: $_FORM[0].dobMonth.value,
                    dobYear: $_FORM[0].dobYear.value,
                    acceptMktg: $_FORM[0].acceptMktg.checked,
                    privacyPolicyAccepted: true,
                    tosAccepted: $_FORM[0].tosAccepted.checked,
                    cid: wpCookie("cmpID30"),
                    gvid: wpCookie("soegvid"),
                    responseType: "json",
                    theme: globs.wdl.theme,
                    ts: new Date().getTime(),
                    locale: globs.soelocale
                };
                if (window.betaId) {
                    formData.betaReg = true;
                    formData.betaId = window.betaId;
                }
                $('.create-group .btn', $_FORM).prop('disabled', true).addClass('working');
                $.ajax({
                    url: submitUrl,
                    dataType: "json",
                    type: "post",
                    data: formData,
                    success: registrationSuccess,
                    error: registrationError
                });
            }
        };
        var registrationSuccess = function(data) {
            if (data.errors.length > 0) {
                registrationUramErrors(data);
            } else {
                logUserOut();
                logUserIn(data.betaSignUp);
            }
        };
        var registrationUramErrors = function(data) {
            var error;
            for (error in data.fieldErrors) {
                if (data.fieldErrors.hasOwnProperty(error)) {
                    $_FORM.find("[name=" + error + "]").parents(".form-group").addClass("has-error");
                }
            }
            $('.create-group .btn', $_FORM).prop('disabled', false).removeClass('working');
            $_GLOBAL_ERROR.removeClass("hidden").html(data.errors.join("<br />"));
        };
        var registrationError = function() {
            $('.create-group .btn', $_FORM).prop('disabled', false).removeClass('working');
            $_GLOBAL_ERROR.removeClass("hidden").html("We're sorry, but you are unable to sign up for a Daybreak Account at this time.");
        };
        var logUserIn = function(betaSignUp) {
            var returnUrl = $_AUTO_LOGIN[0].service.value;
            if (betaSignUp) {
                if (returnUrl.indexOf("?") !== -1) {
                    returnUrl += "&betaSignUp=" + betaSignUp;
                } else {
                    returnUrl += "?betaSignUp=" + betaSignUp;
                }
            }
            if (typeof globs.urlparameters !== "undefined" && typeof globs.urlparameters.launchPoint !== "undefined") {
                if (returnUrl.indexOf("?") !== -1) {
                    returnUrl += "&launchPoint=" + globs.urlparameters.launchPoint;
                } else {
                    returnUrl += "?launchPoint=" + globs.urlparameters.launchPoint;
                }
            }
            $_AUTO_LOGIN[0].username.value = $_FORM[0].getElementById("wrCreateUsername").value;
            $_AUTO_LOGIN[0].password.value = $_FORM[0].password1.value;
            $_AUTO_LOGIN[0].service.value = returnUrl;
            $_AUTO_LOGIN[0].gvid.value = wpCookie("soegvid");
            $_AUTO_LOGIN[0].submit();
        };
        var logUserOut = function() {
            if (globs.wdl.username) {
                document.createElement("img").src = globs.urls.logout;
            }
        };
        return {
            submitForm: submitForm
        };
    })();
    $_FORM[0].reset();
    FormEvents.init();
    return {
        submitUrl: submitUrl,
        returnUrl: returnUrl,
        underage: underage,
        gotCountries: CountrySelection.gotCountryList,
        FormProcessor: FormProcessor
    };
})();
$(document).ready(function() {
    try {
        DTKR.trackFunnelEvent("REGISTRATION_VIEWED", null, {
            campaignAttribution: 30
        });
    } catch (e) {}
});

/* end /web-platform/scripts/web-platform/reg/registration2.js*/

/* start /scripts/v4/_pages/register.js*/
$(document).ready(function() {
    'use strict';

    function canSubmitEmailForm($form) {
        var isValidEmail = DCUO.validateEmail($('.email-address', $form).val().trim());
        var allTOSPPChecked = $('.tos-pp input:not(:checked)', $form).length === 0;
        return isValidEmail && allTOSPPChecked;
    }
    $('a[data-store-type]').on('shown.bs.tab', function() {
        $('.registration-header .header-cta').addClass('hidden').filter('.' + $(this).attr('data-store-type')).removeClass('hidden');
    });
    $(document).on('regUnderageLockout', function() {
        $('.email-group').html($('#consoleUnderageTemplate').html());
        $('.continue-to-store').html('Continue to Store');
        $('.extra-disclaimers').html('');
    });
    $('.email-form').on('keydown keypress change input', 'input', function() {
        var $thisForm = $(this).parents('.email-form');
        $('.email-submit', $thisForm).prop('disabled', !canSubmitEmailForm($thisForm));
    });
    $('.email-form').on('submit', function(e) {
        e.preventDefault();
        var $this = $(this);
        var cid = $this.attr('data-cid');
        var emailAddress = $('.email-address', $this).val().trim();
        var storeUrl = $this.parents('.tab-pane').find('.continue-to-store').attr('href');
        if (canSubmitEmailForm($this)) {
            $this.addClass('working');
            $.ajax({
                url: globs.urls.appengRestUrl + '/rest/saveEmail',
                type: 'POST',
                data: {
                    campaignId: cid,
                    email: emailAddress
                },
                dataType: 'json',
                timeout: 10000
            }).done(function(data) {
                $this.removeClass('working');
                if (data) {
                    if (data.success) {
                        $this.addClass('success');
                        if (storeUrl) {
                            window.location.href = storeUrl;
                        }
                    } else {
                        $this.addClass('error');
                        $('.result-error', $this).html('General problem: ' + data.errorsList.join(', '));
                    }
                } else {
                    $this.addClass('error');
                    $('.result-error', $this).html('A server error occurred. Please try again later.');
                }
            }).fail(function() {
                $this.removeClass('working').addClass('error');
                $('.result-error', $this).html('A network error occurred. Please try again later.');
            });
        }
    });
});

/* end /scripts/v4/_pages/register.js*/

/* start /web-platform/scripts/web-platform/component/global-nav.js*/
(function() {
    'use strict';
    var nonMember = _.template($('script.non-member').html());
    var member = _.template($('script.member').html());
    if (globs.wdl.userLoggedIn) {
        $.ajax({
            url: '/get-rest-ticket',
            type: 'POST',
            data: {
                type: 0
            },
            context: this,
            success: function(sid) {
                $.ajax({
                    url: globs.urls.uramAjaxUrl + '/rest/commerce/11/allaccessinfo.action',
                    dataType: 'json',
                    data: {
                        'theme': globs.wdl.theme,
                        'responseType': 'json',
                        'sessionID': sid.successPayload.ticket
                    },
                    success: function(data) {
                        var memberData = {
                            scGrantDate: data.scGrantDate,
                            scGrantClaimed: data.scGrantClaimed,
                            expirationDate: data.expirationDate
                        };
                        $('.currency-balance-item').each(function() {
                            var $this = $(this);
                            var presenceField = $this.attr('data-currency-presence-field');
                            var balanceField = $this.attr('data-currency-balance-field');
                            if (!presenceField || (Object.hasOwnProperty.call(data, presenceField) && data[presenceField] === true)) {
                                if (Object.hasOwnProperty.call(data, balanceField)) {
                                    $this.removeClass('hidden').find('.currency-balance').text(SOE.Utils.addSeparators(data[balanceField]));
                                }
                            }
                        });
                        if (!data.akella) {
                            if (!data.member) {
                                $('#brandBarAllAccess').html(nonMember());
                            } else {
                                $('#brandBarAllAccess').html(member(memberData));
                                $('#brandBarIsMember').text('My');
                                $('#membershipLink').click(function(e) {
                                    e.preventDefault();
                                    window.location.href = globs.urls.membershipMembership;
                                });
                            }
                            $('ul#brandBarOptions').trigger('reset');
                        }
                    }
                });
            }
        });
    } else {
        $('#brandBarAllAccess').html(nonMember());
    }
})();

/* end /web-platform/scripts/web-platform/component/global-nav.js*/

/* start /scripts/v4/components/newsletter-modal.js*/
$(document).ready(function() {
    'use strict';

    function emailFieldOK() {
        return DCUO.validateEmail($('#newsletterModalEmail').val().trim());
    }

    function atLeastOneSystemChosen() {
        return $('#newsletterModalForm .system-select input:checked').length > 0 ? true : false;
    }

    function allTOSPPChecked() {
        return $('#newsletterModalForm .tos-pp input:not(:checked)').length === 0;
    }

    function updateSubmitButtonState() {
        $('#newsletterModalSubmit').prop('disabled', !(emailFieldOK() && atLeastOneSystemChosen() && allTOSPPChecked()));
    }

    function requestSuccessfulOrUndefined(req) {
        if (req) {
            return (req[0] && req[0].success) ? true : false;
        } else {
            return true;
        }
    }

    function requestHasErrors(req) {
        if (req) {
            return (req[0] && req[0].errorsList) ? true : false;
        } else {
            return false;
        }
    }

    function reduceErrors(list, req) {
        if (req && req[0] && req[0].errorsList) {
            return list.concat(req[0].errorsList);
        } else {
            return list;
        }
    }
    $('#nwsltrSignup').on('click', function() {
        $('#nwsltrModal').modal();
        updateSubmitButtonState();
    });
    $('#newsletterModalForm input').on('keydown keypress change input', function() {
        updateSubmitButtonState();
    });
    $('#newsletterModalForm').on('submit', function(e) {
        e.preventDefault();
        var $newsletterModal = $('#nwsltrModal');
        var $errorText = $('.result-error', $newsletterModal);
        var emailAddress = $('#newsletterModalEmail').val().trim();
        var saves = [];
        var errorsList;
        if (emailFieldOK() && atLeastOneSystemChosen() && allTOSPPChecked()) {
            $newsletterModal.addClass('working');
            $('#newsletterModalForm .system-select input:checked').each(function(i, e) {
                var cid = $(e).attr('data-cid');
                saves.push($.ajax({
                    url: globs.urls.appengRestUrl + '/rest/saveEmail',
                    type: 'POST',
                    data: {
                        campaignId: cid,
                        email: emailAddress
                    },
                    dataType: 'json',
                    timeout: 10000
                }));
            });
            $.when.apply($, saves).done(function(a1, a2, a3) {
                var results;
                $newsletterModal.removeClass('working');
                if (saves.length == 1) {
                    results = [
                        [a1, a2, a3], undefined, undefined
                    ];
                } else {
                    results = [a1, a2, a3];
                }
                if (_.every(results, requestSuccessfulOrUndefined)) {
                    $newsletterModal.addClass('success');
                } else if (_.some(results, requestHasErrors)) {
                    $newsletterModal.addClass('error');
                    errorsList = _.uniq(_.reduce(results, reduceErrors, []));
                    $errorText.html('General problem: ' + errorsList.join(', '));
                } else {
                    $newsletterModal.addClass('error');
                    $errorText.html('A server error occurred. Please try again later.');
                }
            }).fail(function() {
                $newsletterModal.removeClass('working').addClass('error');
                $errorText.html('A network error occurred. Please try again later.');
            });
        }
    });
});

/* end /scripts/v4/components/newsletter-modal.js*/