package controllers

import (
	"net/http"

	"github.com/otiai10/gosseract/v2"
	"github.com/otiai10/marmoset"
)

const version = "0.2.0"

// Status ...
func Status(w http.ResponseWriter, r *http.Request) {
	langs, err := gosseract.GetAvailableLanguages()
	if err != nil {
		marmoset.Render(w, true).JSON(http.StatusInternalServerError, marmoset.P{
			"error": err,
		})
		return
	}
	ocrVersion := gosseract.Version()

	client := gosseract.NewClient()
	defer client.Close()
	marmoset.Render(w, true).JSON(http.StatusOK, marmoset.P{
		"message": "Hello!",
		"version": version,
		"tesseract": marmoset.P{
			"version":   ocrVersion,
			"languages": langs,
		},
	})
}
