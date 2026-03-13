# syntax=docker/dockerfile:1
# Use lightweight node alpine image
FROM node:22-alpine
 
# Set working directory
WORKDIR /app
 
# Copy only package files first (layer caching)
COPY TODO/todo_backend/package*.json ./
 
# Install only production dependencies
RUN npm ci --omit=dev
 
# Copy backend source files
COPY TODO/todo_backend/static ./static/build
 
# Copy pre-built frontend static files
COPY TODO/todo_backend/static ./static
 
# Set environment variables
ENV PORT=5000
ENV MONGODB_URI=""
 
# Expose port 5000
EXPOSE 5000
 
# Start the server
CMD ["npm", "start"]
 