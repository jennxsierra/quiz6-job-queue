package main

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

func (app *application) routes() http.Handler {
	router := httprouter.New()

	// Handle 404 and 405 errors with custom responses
	router.NotFound = http.HandlerFunc(app.notFoundResponse)
	router.MethodNotAllowed = http.HandlerFunc(app.methodNotAllowedResponse)

	// Index Route
	router.HandlerFunc(http.MethodGet, "/", app.indexHandler)

	return app.logRequest(app.recoverPanic(router))
}
