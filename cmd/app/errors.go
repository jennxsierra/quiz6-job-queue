package main

import (
	"fmt"
	"net/http"
)

// logError records error messages, HTTP request method, and URI 
func (app *application) logError(r *http.Request, err error) {
	app.logger.Error(err.Error(),
		"method", r.Method,
		"uri", r.URL.RequestURI(),
	)
}

// errorResponse sends a JSON response with an error message to the client
func (app *application) errorResponse(w http.ResponseWriter, r *http.Request, status int, message any) {
	data := envelope{"error": message}

	err := app.writeJSON(w, status, data, nil)
	if err != nil {
		app.logError(r, err)
		w.WriteHeader(http.StatusInternalServerError)
	}
}

// serverErrorResponse logs the error and sends a generic 500 error response to the client
func (app *application) serverErrorResponse(w http.ResponseWriter, r *http.Request, err error) {
	app.logError(r, err)

	message := "the server encountered a problem and could not process your request"
	app.errorResponse(w, r, http.StatusInternalServerError, message)
}

// notFoundResponse sends a 404 Not Found response to the client
func (app *application) notFoundResponse(w http.ResponseWriter, r *http.Request) {
	message := "the requested resource could not be found"
	app.errorResponse(w, r, http.StatusNotFound, message)
}

// methodNotAllowedResponse sends a 405 Method Not Allowed response to the client
func (app *application) methodNotAllowedResponse(w http.ResponseWriter, r *http.Request) {
	message := fmt.Sprintf("the %s method is not supported for this resource", r.Method)
	app.errorResponse(w, r, http.StatusMethodNotAllowed, message)
}
