from django.test import TestCase

class HealthCheckTests(TestCase):
    def test_health_endpoint_ignores_allowed_hosts(self):
        # ALB wysyła Host = prywatne IP instancji - /health/ ma zwracać 200

        response = self.client.get("/health/", HTTP_HOST="10.0.1.25")
        self.assertEqual(response.status_code, 200)
