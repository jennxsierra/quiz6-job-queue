package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func (a *application) serve() error {
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%d", a.config.port),
		Handler:      a.routes(),
		IdleTimeout:  time.Minute,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 30 * time.Second, // increased for slow demo endpoint
		ErrorLog:     slog.NewLogLogger(a.logger.Handler(), slog.LevelError),
	}

	// create a channel to keep track of any errors during the shutdown process
	shutdownError := make(chan error)

	// create a goroutine that runs in the background listening
	// for the shutdown signals
	go func() {
		quit := make(chan os.Signal, 1)                      // receive the shutdown signal
		signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM) // signal occurred
		s := <-quit                                          // blocks until a signal is received

		// print newline to ensure the shutdown message appears on a new line
		fmt.Println()

		// message about shutdown in process
		shutdownTimeout := 30 * time.Second
		a.logger.Info("shutting down server", "signal", s.String(), "timeout", shutdownTimeout.String())

		// create a context
		ctx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
		defer cancel()

		// only write to the error channel if there is an error during shutdown
		err := srv.Shutdown(ctx)
		if err != nil {
			shutdownError <- err
		}

		// wait for any background tasks to complete
		a.logger.Info("completing background tasks", "address", srv.Addr)
		a.wg.Wait()
		shutdownError <- nil // successful shutdown
	}()

	// server keeps running until we receive a shutdown signal
	err := srv.ListenAndServe()
	if !errors.Is(err, http.ErrServerClosed) {
		return err
	}

	// check the error channel to see if there were shutdown errors
	err = <-shutdownError
	if err != nil {
		return err
	}

	// graceful shutdown was successful
	a.logger.Info("stopped server", "address", srv.Addr)

	return nil
}
