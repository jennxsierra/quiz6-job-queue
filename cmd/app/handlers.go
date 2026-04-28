package main

import "net/http"

// indexHandler writes a JSON response containing a welcome message and the application version
func (app *application) indexHandler(w http.ResponseWriter, r *http.Request) {
	data := envelope{
		"message": "Welcome to the simple Go server",
		"version": version,
	}

	err := app.writeJSON(w, http.StatusOK, data, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}
