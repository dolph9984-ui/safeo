export const OAUTH_ERROR_MESSAGES: Record<string, string> = {
  access_denied:
    "Vous avez refusé l'accès. Veuillez réessayer et accepter les permissions.",
  invalid_request:
    "La demande d'authentification est invalide. Veuillez réessayer.",
  unauthorized_client:
    "L'application n'est pas autorisée. Contactez le support.",
  invalid_scope: 'Les permissions demandées sont invalides.',
  server_error: 'Erreur du serveur Google. Veuillez réessayer plus tard.',
  temporarily_unavailable:
    'Le service est temporairement indisponible. Réessayez dans quelques instants.',
};
