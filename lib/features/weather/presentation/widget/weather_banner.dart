import 'package:blocnewsapp/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:blocnewsapp/features/weather/presentation/cubit/weather_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBanner extends StatelessWidget {
  const WeatherBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: state is WeatherStateLoading
              ? const Center(child: CupertinoActivityIndicator())
              : state is WeatherStateError
              ? const SizedBox.shrink()
              : state is WeatherStateLoaded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.weather?.temperature}°C',
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.weather?.description ?? 'No description',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      state.weather?.cityName ?? 'Unknown location',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    Text(
                      'Last updated: ${state.weather?.icon ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        );
      },
    );
  }
}
