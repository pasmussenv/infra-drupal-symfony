<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class DefaultController extends AbstractController
{
    #[Route('/symfony', name: 'symfony_index')]
    public function index(): JsonResponse
    {
        return $this->json([
            'message' => '¡Symfony funciona correctamente en /symfony!',
            'status' => 'success',
        ]);
    }
}
