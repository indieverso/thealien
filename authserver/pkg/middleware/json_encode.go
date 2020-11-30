package middleware

import "net/http"

// JSONEncodeMiddleware makes the response content-type as application/json
func JSONEncodeMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Content-Type", "application/json")
		next.ServeHTTP(w, r)
	})
}
